import os
from contextlib import asynccontextmanager

import asyncpg
from dotenv import load_dotenv
from fastapi import FastAPI, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

load_dotenv()
DATABASE_URL = os.environ["DATABASE_URL"]


class Provider(BaseModel):
    id: int
    name: str
    trade: str
    description: str
    lat: float
    lng: float
    distance_m: float | None = None

class ProviderCreate(BaseModel):
    name: str
    trade: str
    description: str
    lat: float
    lng: float

@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.pool = await asyncpg.create_pool(DATABASE_URL)
    yield
    await app.state.pool.close()


app = FastAPI(title="Oficios Cerca API", lifespan=lifespan)

# CORS: permite que la app Flutter (en el navegador) consuma la API.
# En producción se restringe al dominio real.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.get("/providers/nearby", response_model=list[Provider])
async def providers_nearby(
    request: Request,
    lat: float = Query(..., description="Latitud del usuario"),
    lng: float = Query(..., description="Longitud del usuario"),
    radius_m: int = Query(5000, description="Radio de búsqueda en metros"),
    limit: int = Query(50, le=200),
):
    query = """
        SELECT id, name, trade, description,
               ST_Y(location::geometry) AS lat,
               ST_X(location::geometry) AS lng,
               ST_Distance(location, ST_MakePoint($1, $2)::geography) AS distance_m
        FROM providers
        WHERE ST_DWithin(location, ST_MakePoint($1, $2)::geography, $3)
        ORDER BY distance_m
        LIMIT $4;
    """
    async with request.app.state.pool.acquire() as conn:
        rows = await conn.fetch(query, lng, lat, radius_m, limit)
    return [dict(r) for r in rows]

@app.post("/providers", response_model=Provider, status_code=201)
async def create_provider(payload: ProviderCreate, request: Request):
    query = """
        INSERT INTO providers (name, trade, description, location)
        VALUES ($1, $2, $3, ST_MakePoint($4, $5)::geography)
        RETURNING id, name, trade, description,
                  ST_Y(location::geometry) AS lat,
                  ST_X(location::geometry) AS lng;
    """
    async with request.app.state.pool.acquire() as conn:
        row = await conn.fetchrow(
            query,
            payload.name, payload.trade, payload.description,
            payload.lng, payload.lat,  # OJO: lng, lat (orden de PostGIS)
        )
    return dict(row)
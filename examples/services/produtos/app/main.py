import logging
import os
from contextlib import contextmanager

import psycopg
from fastapi import FastAPI

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("produtos")

app = FastAPI(title="Produtos API", version="1.0.0")

DATABASE_URL = os.getenv("DATABASE_URL")


@contextmanager
def db():
    if not DATABASE_URL:
        raise RuntimeError("DATABASE_URL is not configured")
    with psycopg.connect(DATABASE_URL) as conn:
        yield conn


def ensure_schema():
    with db() as conn:
        conn.execute(
            """
            create table if not exists produtos (
              id serial primary key,
              nome text not null,
              sku text not null unique,
              estoque integer not null default 0
            )
            """
        )
        conn.execute(
            """
            insert into produtos (nome, sku, estoque)
            values
              ('Notebook DevPlane', 'NB-DEV-001', 8),
              ('Monitor Observability', 'MN-OBS-002', 13),
              ('Keyboard GitOps', 'KB-GIT-003', 21)
            on conflict (sku) do nothing
            """
        )
        conn.commit()


@app.on_event("startup")
def startup():
    ensure_schema()
    logger.info("produtos service started")


@app.get("/health")
def health():
    return {"status": "ok", "service": "produtos"}


@app.get("/produtos")
def listar_produtos():
    logger.info("listing produtos")
    with db() as conn:
        rows = conn.execute(
            "select id, nome, sku, estoque from produtos order by id"
        ).fetchall()
    return [
        {"id": row[0], "nome": row[1], "sku": row[2], "estoque": row[3]}
        for row in rows
    ]


@app.post("/produtos/{sku}/entrada")
def entrada_estoque(sku: str, quantidade: int = 1):
    logger.info("adding inventory", extra={"sku": sku, "quantidade": quantidade})
    with db() as conn:
        row = conn.execute(
            """
            update produtos
            set estoque = estoque + %s
            where sku = %s
            returning id, nome, sku, estoque
            """,
            (quantidade, sku),
        ).fetchone()
        conn.commit()
    if row is None:
        return {"updated": False, "sku": sku}
    return {"updated": True, "produto": {"id": row[0], "nome": row[1], "sku": row[2], "estoque": row[3]}}

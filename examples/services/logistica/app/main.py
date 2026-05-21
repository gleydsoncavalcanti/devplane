import logging
import os
from contextlib import contextmanager

import psycopg
from fastapi import FastAPI

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("logistica")

app = FastAPI(title="Logistica API", version="1.0.0")

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
            create table if not exists entregas (
              id serial primary key,
              codigo text not null unique,
              destino text not null,
              status text not null
            )
            """
        )
        conn.execute(
            """
            insert into entregas (codigo, destino, status)
            values
              ('ENT-1001', 'Recife', 'em_rota'),
              ('ENT-1002', 'Fortaleza', 'separacao'),
              ('ENT-1003', 'Sao Paulo', 'entregue')
            on conflict (codigo) do nothing
            """
        )
        conn.commit()


@app.on_event("startup")
def startup():
    ensure_schema()
    logger.info("logistica service started")


@app.get("/health")
def health():
    return {"status": "ok", "service": "logistica"}


@app.get("/entregas")
def listar_entregas():
    logger.info("listing deliveries")
    with db() as conn:
        rows = conn.execute(
            "select id, codigo, destino, status from entregas order by id"
        ).fetchall()
    return [
        {"id": row[0], "codigo": row[1], "destino": row[2], "status": row[3]}
        for row in rows
    ]


@app.post("/entregas/{codigo}/status")
def atualizar_status(codigo: str, status: str):
    logger.info("updating delivery status", extra={"codigo": codigo, "status": status})
    with db() as conn:
        row = conn.execute(
            """
            update entregas
            set status = %s
            where codigo = %s
            returning id, codigo, destino, status
            """,
            (status, codigo),
        ).fetchone()
        conn.commit()
    if row is None:
        return {"updated": False, "codigo": codigo}
    return {"updated": True, "entrega": {"id": row[0], "codigo": row[1], "destino": row[2], "status": row[3]}}

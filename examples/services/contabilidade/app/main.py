import logging
import os
from contextlib import contextmanager
from decimal import Decimal

import psycopg
from fastapi import FastAPI

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("contabilidade")

app = FastAPI(title="Contabilidade API", version="1.0.0")

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
            create table if not exists lancamentos (
              id serial primary key,
              conta text not null,
              descricao text not null,
              valor numeric(12,2) not null
            )
            """
        )
        conn.execute(
            """
            insert into lancamentos (conta, descricao, valor)
            values
              ('receita', 'Venda de produtos', 18240.50),
              ('despesa', 'Infraestrutura DevPlane', -1190.90),
              ('receita', 'Servicos logisticos', 4200.00)
            on conflict do nothing
            """
        )
        conn.commit()


@app.on_event("startup")
def startup():
    ensure_schema()
    logger.info("contabilidade service started")


@app.get("/health")
def health():
    return {"status": "ok", "service": "contabilidade"}


@app.get("/balanco")
def balanco():
    logger.info("calculating balance")
    with db() as conn:
        rows = conn.execute(
            "select conta, coalesce(sum(valor), 0) from lancamentos group by conta order by conta"
        ).fetchall()
        total = conn.execute("select coalesce(sum(valor), 0) from lancamentos").fetchone()[0]
    return {
        "contas": [{"conta": row[0], "valor": float(row[1])} for row in rows],
        "total": float(total),
    }


@app.post("/lancamentos")
def criar_lancamento(conta: str, descricao: str, valor: Decimal):
    logger.info("creating accounting entry", extra={"conta": conta, "valor": str(valor)})
    with db() as conn:
        row = conn.execute(
            """
            insert into lancamentos (conta, descricao, valor)
            values (%s, %s, %s)
            returning id, conta, descricao, valor
            """,
            (conta, descricao, valor),
        ).fetchone()
        conn.commit()
    return {"id": row[0], "conta": row[1], "descricao": row[2], "valor": float(row[3])}

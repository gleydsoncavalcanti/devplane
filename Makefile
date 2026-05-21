SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

.PHONY: help install-cli install-prereqs up down status hosts cluster-create cluster-delete cluster-status cluster-appsets cluster-hosts

help:
	@./scripts/devplane help

install-cli:
	@./scripts/install-cli

install-prereqs:
	@./scripts/devplane install-prereqs

up:
	@./scripts/devplane up

down:
	@./scripts/devplane down

status:
	@./scripts/devplane status

hosts:
	@./scripts/devplane hosts

cluster-create:
	@./scripts/devplane cluster create

cluster-delete:
	@./scripts/devplane cluster delete

cluster-status:
	@./scripts/devplane cluster status

cluster-appsets:
	@./scripts/devplane cluster appsets

cluster-hosts:
	@./scripts/devplane cluster hosts

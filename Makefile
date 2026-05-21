SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

.PHONY: help install-cli install-prereqs up down status hosts cluster-add cluster-generate cluster-remove cluster-workloads cluster-workload cluster-create cluster-delete cluster-status cluster-appsets cluster-hosts

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

cluster-add:
	@./scripts/devplane cluster add $(NAME)

cluster-generate:
	@./scripts/devplane cluster generate $(NAME)

cluster-remove:
	@./scripts/devplane cluster remove $(NAME)

cluster-workloads:
	@./scripts/devplane cluster workloads

cluster-workload:
	@./scripts/devplane cluster workloads

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

all:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env up --build -d

down:
	docker compose -f srcs/docker-compose.yml down

fclean:
	docker compose -f srcs/docker-compose.yml down --volumes --remove-orphans --rmi all
	rm -rf srcs/requirements/mariadb/data/*

re: fclean all

.PHONY: all down fclean re



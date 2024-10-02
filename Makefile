# with @, doesn't show the command in the CLI

build:
	@go build -o bin/jim-carrier cmd/main.go

test:
	@go test -v ./...
	
run: build
	@./bin/jim-carrier

# run:
# 	@go run cmd/main.go

migration:
	@migrate create -ext sql -dir cmd/migrate/migrations $(filter-out $@,$(MAKECMDGOALS))

migrate-up:
	@go run cmd/migrate/main.go up

migrate-down:
	@go run cmd/migrate/main.go down

migrate-force:
	@migrate -path PATH_TO_YOUR_MIGRATIONS -database YOUR_DATABASE_URL force VERSION

migrate-cmd:
	@cmd.exe /c '..\BACKEND\cmd\migrate\db_migrate.bat'

migrate-rm:
	del .\cmd\migrate\migrations\*.sql

init-admin:
	@go run cmd/init/InitAdmin.go $(username)

dummy-data:
	@python3 -u cmd/init/create_dummy_data.py

get-dummy-data:
	@python3 -u cmd/init/get_dummy_data.py

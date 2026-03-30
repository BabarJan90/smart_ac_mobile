G='\033[0;32m'   #'0;32' is Green's ANSI color code

get:
	flutter pub get
	@echo "${G}pub get has completed successfully"

gen:
	dart run build_runner build --delete-conflicting-outputs
	@echo "${G}build runner has completed successfully"

analyze:
	dart analyze . --fatal-infos
	@echo "${G}analyzer has completed successfully"

coverage:
	flutter test --coverage
	@echo "${G}coverage file was generated"

coverage-html:
	 genhtml coverage/lcov.info --config-file .lcovrc -o coverage/html && open coverage/html/index.html
	 @echo "${G}coverage html file was generated"
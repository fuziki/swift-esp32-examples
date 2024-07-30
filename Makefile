help:
	@echo "export: . ../scripts/export.sh"
	@echo "setup:  idf.py set-target esp32c6"
	@echo "build:  idf.py build"
	@echo "flash:  idf.py flash monitor"

project:
	xcrun --sdk macosx swift run --package-path tools xcodegen --spec project.yml

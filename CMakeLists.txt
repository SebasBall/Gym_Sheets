cmake_minimum_required(VERSION 3.16)
project(Gym_Sheets LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Qml Sql)
qt_standard_project_setup()

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

file(GLOB_RECURSE CPP_Files
	RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
	"CPP/*.cpp"
	"CPP/*.h"
	"CPP/*.c"
)

qt_add_executable(Gym_Sheets main.cpp ${CPP_Files})
target_include_directories(Gym_Sheets PRIVATE CPP)

file(GLOB_RECURSE QML_Singletons
	RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
	"GeneralQml/Singletons/*.qml"
)

set_source_files_properties(
	${QML_Singletons}
	PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

file(GLOB_RECURSE QML_Files
	RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
	"GeneralQml/*.qml"
	"ScreensQml/*.qml"
	"AppQml/*.qml"
	"AppQml/*.js"
	"GeneralQml/*.js"
	"ScreensQml/*.js"
)

qt_add_qml_module(Gym_Sheets
    URI Gym_Sheets
    VERSION 1.0
    QML_FILES
		Main.qml
		${QML_Files}
	SOURCES
		${CPP_Files}
)

file(GLOB_RECURSE SQL_Files
	RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
	"SQL/*.sql"
)

qt_add_resources(Gym_Sheets "SQL"
	PREFIX "SQL"
	BASE "SQL"
	FILES ${SQL_Files}
)

qt_add_resources(Gym_Sheets "Fonts"
    PREFIX "/Fonts"
    BASE "Fonts"
    FILES Fonts/Lexend-VariableFont_wght.ttf
)

target_link_libraries(Gym_Sheets PRIVATE Qt6::Quick Qt6::Sql)

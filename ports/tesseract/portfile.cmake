if(NOT VCPKG_TARGET_IS_WINDOWS)
    set(tesseract_patch fix-depend-libarchive.patch)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tesseract-ocr/tesseract
    REF 080da83cc51c4ef8b324a7e03146fe0bd7e0944b #5.3.0
    SHA512 77f7e69ca220edb51f0d1e21fae67288759bbefb6868203cd095c4457b16d7319d78cd47dd8e72be3da5aabb357f5f649b8da7fc3f2263faedecf10f556eb431
    PATCHES
        ${tesseract_patch}
        fix-tools.patch # See https://github.com/tesseract-ocr/tesseract/pull/4006
        fix-debug-postfix.patch # See https://github.com/tesseract-ocr/tesseract/pull/4008
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        training-tools  BUILD_TRAINING_TOOLS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUSE_SYSTEM_ICU=True
        -DCMAKE_REQUIRE_FIND_PACKAGE_LibArchive=ON
        -DCMAKE_REQUIRE_FIND_PACKAGE_CURL=ON
        -DCMAKE_REQUIRE_FIND_PACKAGE_Leptonica=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_OpenCL=ON
        -DLeptonica_DIR=YES
        -DSW_BUILD=OFF
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_OpenCL
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/tesseract)

vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/tesseract/TesseractConfig.cmake"
    "find_dependency(Leptonica)"
[[
find_dependency(CURL)
find_dependency(Leptonica)
find_dependency(LibArchive)
]]
)

vcpkg_copy_tools(TOOL_NAMES tesseract AUTO_CLEAN)
vcpkg_fixup_pkgconfig()

if("training-tools" IN_LIST FEATURES)
    list(APPEND TRAINING_TOOLS
        ambiguous_words classifier_tester combine_tessdata
        cntraining dawg2wordlist mftraining shapeclustering
        wordlist2dawg combine_lang_model lstmeval lstmtraining
        set_unicharset_properties unicharset_extractor text2image
        merge_unicharsets
    )
    vcpkg_copy_tools(TOOL_NAMES ${TRAINING_TOOLS} AUTO_CLEAN)
endif()


file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Install:
file(GLOB API_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/api/*.h")
file(INSTALL ${API_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/api")

file(GLOB ARCH_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/arch/*.h")
file(INSTALL ${ARCH_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/arch")

file(GLOB CCMAIN_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/ccmain/*.h")
file(INSTALL ${CCMAIN_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/ccmain")

file(GLOB CCSTRUCT_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/ccstruct/*.h")
file(INSTALL ${CCSTRUCT_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/ccstruct")

file(GLOB CCUTIL_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/ccutil/*.h")
file(INSTALL ${CCUTIL_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/ccutil")

file(GLOB CLASSIFY_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/classify/*.h")
file(INSTALL ${CLASSIFY_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/classify")

file(GLOB CUTIL_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/cutil/*.h")
file(INSTALL ${CUTIL_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/cutil")

file(GLOB DICT_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/dict/*.h")
file(INSTALL ${DICT_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/dict")

file(GLOB LSTM_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/lstm/*.h")
file(INSTALL ${LSTM_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/lstm")

file(GLOB TEXTORD_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/textord/*.h")
file(INSTALL ${TEXTORD_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/textord")

file(GLOB VIEWER_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/viewer/*.h")
file(INSTALL ${VIEWER_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/viewer")

file(GLOB WORDREC_HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/src/wordrec/*.h")
file(INSTALL ${WORDREC_HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/tesseract/wordrec")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

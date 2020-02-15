{
  "app-id": "org.gnucash.GnuCash",
  "runtime": "org.gnome.Platform",
  "runtime-version": "3.34",
  "sdk": "org.gnome.Sdk",
  "command": "gnucash",
  "copy-icon": true,
  "rename-icon": "gnucash-icon",
  "rename-desktop-file": "gnucash.desktop",
  "rename-appdata-file": "gnucash.appdata.xml",
  "finish-args": [
    "--socket=wayland",
    "--socket=x11",
    "--share=ipc",
    "--share=network",
    "--filesystem=home",
    "--filesystem=xdg-run/dconf", "--filesystem=~/.config/dconf:ro",
    "--talk-name=ca.desrt.dconf", "--env=DCONF_USER_CONFIG_DIR=.config/dconf"
  ],
  "cleanup": [
    "*.a",
    "*.la",
    "/include",
    "/lib/pkgconfig"
  ],
  "modules": [
    "modules/guile.json",
    {
      "name": "opensp",
      "rm-configure": true,
      "config-opts": [ "--disable-doc-build" ],
      "sources": [
          {
              "type": "archive",
              "url": "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz",
              "sha256": "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"
          },
          {
              "type": "script",
              "dest-filename": "autogen.sh",
              "commands": [
                  "autoreconf -vfi"
              ]
          }
      ]
    },
    {
      "name": "gengetopt",
      "config-opts": [
          "--prefix=/app"
          ],
      "rm-configure": true,
      "sources": [
          {
              "type": "archive",
              "url": "https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.6.tar.gz",
              "sha256": "30b05a88604d71ef2a42a2ef26cd26df242b41f5b011ad03083143a31d9b01f7"
          },
          {
              "type": "patch",
              "path": "gengetopt-makefile.patch"
          },
          {
              "type": "script",
              "dest-filename": "autogen.sh",
              "commands": [
                  "autoreconf -vfi"
              ]
          }
      ]
    },
    {
      "name": "libofx",
      "no-parallel-make": true,
      "config-opts": [
          "--with-opensp-includes=/app/include/OpenSP",
          "--with-opensp-libs=/lib"
          ],
      "sources": [
          {
              "type": "archive",
              "url": "https://github.com/libofx/libofx/archive/0.9.14.tar.gz",
              "sha256": "85a732efe3026e96fe1cf694ebdcf5d2c3b67adba85b9019abac44e7c43d8ce5"
          }
      ]
    },
    {
      "name": "jemalloc",
      "cleanup": [
        "/bin/",
        "/share"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "https://github.com/jemalloc/jemalloc/releases/download/5.0.1/jemalloc-5.0.1.tar.bz2",
          "sha256": "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9"
        }
      ]
    },
    {
      "name": "libaio",
      "no-autogen": true,
      "make-install-args": [
        "prefix=/app"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_0.3.110.orig.tar.gz",
          "sha256": "e019028e631725729376250e32b473012f7cb68e1f7275bfc1bbcdd0f8745f7e"
        },
        {
          "type": "patch",
          "paths": [
            "link-libs.patch",
            "fix-install-dirs.patch",
            "no-werror.patch",
            "fix-build-flags.patch"
          ]
        }
      ]
    },
    {
      "name": "mariadb",
      "buildsystem": "cmake",
      "no-make-install": true,
      "config-opts": [
        "-DBUILD_CONFIG=mysql_release",
        "-DWITH_INNOBASE_STORAGE_ENGINE=1",
        "-DWITHOUT_ARCHIVE_STORAGE_ENGINE=1",
        "-DWITHOUT_BLACKHOLE_STORAGE_ENGINE=1",
        "-DWITHOUT_PARTITION_STORAGE_ENGINE=1",
        "-DWITHOUT_TOKUDB=1",
        "-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1",
        "-DWITHOUT_FEDERATED_STORAGE_ENGINE=1",
        "-DWITHOUT_PBXT_STORAGE_ENGINE=1"
      ],
      "post-install": [
        "make -C libmysql install",
        "make -C include install",
        "install -Dm755 scripts/mysql_config /app/bin/mysql_config",
        "install -Dm644 support-files/mariadb.pc /app/share/pkgconfig/mariadb.pc"
      ],
      "cleanup": [
        "/bin/"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-10.1.32/source/mariadb-10.1.32.tar.gz",
          "sha256": "0e2aae6a6a190d07c8e36e87dd43377057fa82651ca3c583462563f3e9369096"
        }
      ]
    },
    {
      "name": "postgresql",
      "no-make-install": true,
      "post-install": [
        "make -C src/include install",
        "make -C src/interfaces install",
        "make -C src/bin/pg_config install"
      ],
      "cleanup": [
        "/bin",
        "/share"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "https://ftp.postgresql.org/pub/source/v9.6.8/postgresql-9.6.8.tar.bz2",
          "sha256": "eafdb3b912e9ec34bdd28b651d00226a6253ba65036cb9a41cad2d9e82e3eb70"
        }
      ]
    },
    {
      "name": "libdbi",
      "rm-configure": true,
      "cleanup": [
        "/share"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "http://downloads.sourceforge.net/project/libdbi/libdbi/libdbi-0.9.0/libdbi-0.9.0.tar.gz",
          "sha256": "dafb6cdca524c628df832b6dd0bf8fabceb103248edb21762c02d3068fca4503"
        },
        {
          "type": "shell",
          "commands": [
            "rm -f config.guess"
          ]
        }
      ]
    },
    {
      "name": "libdbi-drivers",
      "rm-configure": true,
      "config-opts": [
        "--disable-docs",
        "--with-dbi-libdir=/app/lib/",
        "--with-dbi-incdir=/app/include/",
        "--with-mysql",
        "--with-pgsql",
        "--with-sqlite3"
      ],
      "cleanup": [
        "/share",
        "/var"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "http://downloads.sourceforge.net/project/libdbi-drivers/libdbi-drivers/libdbi-drivers-0.9.0/libdbi-drivers-0.9.0.tar.gz",
          "sha256": "43d2eacd573a4faff296fa925dd97fbf2aedbf1ae35c6263478210c61004c854"
        },
        {
          "type": "shell",
          "commands": [
            "rm -f config.guess"
          ]
        }
      ]
    },
    {
      "name": "xmlsec",
      "sources": [
        {
          "type": "archive",
          "url": "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.26.tar.gz",
          "sha256": "8d8276c9c720ca42a3b0023df8b7ae41a2d6c5f9aa8d20ed1672d84cc8982d50"
        }
      ]
    },
    {
      "name": "libpcsclite",
      "config-opts": [
        "--disable-libsystemd",
        "--disable-serial",
        "--disable-usb",
        "--disable-libudev",
        "--with-systemdsystemunitdir=no"
      ],
      "sources": [
        {
          "type": "archive",
          "url": "https://pcsclite.apdu.fr/files/pcsc-lite-1.8.24.tar.bz2",
          "sha256": "b81864fa6a5ec776639c02ae89998955f7702a8d10e8b8f70023c5a599d97568"
        }
      ]
    },
    "modules/aqbanking.json",
    {
      "name": "boost",
      "buildsystem": "simple",
      "sources": [
          {
              "type": "archive",
              "url": "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2",
              "sha256": "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"
          }
      ],
      "build-commands": [
          "./bootstrap.sh --prefix=/app --with-libraries=locale,filesystem,system,date_time,regex",
          "./b2 headers",
          "./b2 -j$FLATPAK_BUILDER_N_JOBS install variant=release --layout=system"
        ]
    },
    {
      "name": "googletest",
      "buildsystem": "cmake-ninja",
      "cleanup": ["*"],
      "sources": [
        {
          "type": "archive",
          "url": "https://github.com/google/googletest/archive/release-1.8.0.tar.gz",
          "sha256": "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
        }
      ]
    },
${gnucash_targets}
  ]
}

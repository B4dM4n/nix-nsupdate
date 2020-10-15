{ lib
, fetchFromGitHub
, pkgs
}:
self: super: with self; {
  nsupdate = buildPythonPackage rec {
    pname = "nsupdate";
    version = "0.12.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "071d27kg1b8cz466c4xr4r7b4xh357picj399zzjvrrjp6cili42";
    };

    patches = [ ./keyname.patch ];

    propagatedBuildInputs = [
      dnspython
      netaddr
      requests
      django
      django-bootstrap-form
      django-registration-redux
      django_extensions
      social-auth-app-django
    ];

    doCheck = false;

    meta = with lib; {
      description = "A free dynamic DNS service";
      license = licenses.bsd3;
    };
  };

  django-debug-toolbar = buildPythonPackage rec {
    pname = "django-debug-toolbar";
    version = "3.1.1";

    src = fetchFromGitHub {
      owner = "jazzband";
      repo = pname;
      rev = "${version}";
      sha256 = "sha256-O4VW/he+XHKkN6mN0jCQLs+aHch7dLTsKU6ZTdz940Y=";
    };

    propagatedBuildInputs = [ django sqlparse ];

    checkInputs = [ html5lib jinja2 ];

    checkPhase = "make test";

    meta = with lib; {
      homepage = "https://github.com/jazzband/django-debug-toolbar";
      description = ''
        A configurable set of panels that display various debug information about the current request/response
      '';
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  django-bootstrap-form = buildPythonPackage rec {
    pname = "django-bootstrap-form";
    version = "3.4";

    src = fetchFromGitHub {
      owner = "tzangms";
      repo = pname;
      rev = "ce292cb4f7bcf763796c3bdebc51de07849bc319";
      sha256 = "19dwwbspr6a01dlzkl3phcfmacgvkhshq5p9cda1hdmfxx9gi2i2";
    };

    propagatedBuildInputs = [ django ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/tzangms/django-bootstrap-form";
      description = "Twitter Bootstrap for Django Form";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  django-registration-redux = buildPythonPackage rec {
    pname = "django-registration-redux";
    version = "2.8";

    src = fetchFromGitHub {
      owner = "macropin";
      repo = "django-registration";
      rev = "v${version}";
      sha256 = "sha256-wMOf2ZuaswNysIxGrf5ENNS+EZdRtBlwFUQBDIftSc4=";
    };

    checkInputs = [ pytest pytest-django mock ];

    meta = with lib; {
      homepage = "https://github.com/macropin/django-registration";
      description = "An extensible user-registration application for Django";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  social-auth-core = buildPythonPackage rec {
    pname = "social-auth-core";
    version = "3.3.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-L2zhr47Cssw3uG1kf31OQpLwke5VaUHbNLHg4t7nf8A=";
    };

    postPatch = ''
      substituteInPlace social_core/tests/requirements-base.txt \
        --replace "httpretty==" "httpretty>="
    '';

    nativeBuildInputs = [ pkgs.pkgconfig ];

    propagatedBuildInputs = [ python3-openid six pyjwt oauthlib requests requests_oauthlib python3-saml python-jose ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/python-social-auth/social-core";
      description = "Python social authentication made simple";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  social-auth-app-django = buildPythonPackage rec {
    pname = "social-auth-app-django";
    version = "4.0.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-LGnlffCzDJwYI1GcXxmSy+Tz+Y/cfZXIQOCRp1JwiEA=";
    };

    propagatedBuildInputs = [ social-auth-core ];

    checkInputs = [ mock django ];

    checkPhase = ''
      # the test.html file is missing in the pypi release
      mkdir tests/templates
      echo -n test > tests/templates/test.html

      python manage.py test
    '';

    meta = with lib; {
      homepage = "https://github.com/python-social-auth/social-app-django";
      description = "Python Social Authentication, Django integration";
      license = licenses.bsdOriginal;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  python3-saml = buildPythonPackage rec {
    pname = "python3-saml";
    version = "1.9.0";

    src = fetchFromGitHub {
      owner = "onelogin";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-/yNbocPp6xp8lWzB7hxN2BzNHZ0FUmnvbhvu2LeBsl4=";
    };

    nativeBuildInputs = [ pkgs.pkgconfig python-xmlsec ];

    propagatedBuildInputs = [ isodate python-xmlsec defusedxml lxml ];

    checkInputs = [ freezegun ];

    meta = with lib; {
      homepage = "https://github.com/onelogin/python3-saml";
      description = ''
        Onelogin Python Toolkit. Add SAML support to your Python software using this library
      '';
      license = licenses.mit;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  python-xmlsec = buildPythonPackage rec {
    pname = "xmlsec";
    version = "1.3.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1ki5jiws8r9sbdbbn5cw058m57rhx42g91rrsa2bblqwngi3z546";
    };

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.xmlsec pkgs.libxml2 pkgs.libxslt lxml pkgconfig setuptools_scm toml pkgs.libtool ];

    checkPhase = ''
      python -c 'import xmlsec'
    '';

    meta = with lib; {
      homepage = "https://github.com/mehcode/python-xmlsec";
      description = "Python bindings for the XML Security Library";
      license = licenses.mit;
      maintainers = with maintainers; [ b4dm4n ];
    };
  };

  # setuptools_scm = super.setuptools_scm.overrideAttrs (old: {
  #   propagatedBuildInputs = old.propagatedBuildInputs or [ ] ++ [ toml ];
  # });
  # setuptools_scm = buildPythonPackage rec {
  #   pname = "setuptools_scm";
  #   version = "4.1.2";
  # 
  #   src = fetchPypi {
  #     inherit pname version;
  #     sha256 = "1a7sly8911z46cr7hgsfjzn27gc51z50rizy6c7nkv0nwy14b6d8";
  #   };
  # 
  #   propagatedBuildInputs = [ toml ];
  # 
  #   # Requires pytest, circular dependency
  #   doCheck = false;
  # 
  #   meta = with lib; {
  #     homepage = "https://github.com/pypa/setuptools_scm/";
  #     description = "Handles managing your python package versions in scm metadata";
  #     license = licenses.mit;
  #   };
  # };

  pytest-cov = buildPythonPackage rec {
    pname = "pytest-cov";
    version = "2.10.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-R70M4UBW/defk+FxP4j6173MWD3Nd4Pahu8vCFoLuI4=";
    };
    propagatedBuildInputs = [ pytest coverage ];

    meta = with lib; {
      homepage = "https://github.com/pytest-dev/pytest-cov";
      description = "Pytest plugin for measuring coverage";
      license = licenses.mit;
    };
  };
}

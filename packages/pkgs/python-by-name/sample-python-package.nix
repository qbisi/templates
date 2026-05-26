{
  buildPythonPackage,
  lib,
  python,
  pythonOlder,
}:

buildPythonPackage {
  pname = "sample-python-package";
  version = "0.1.0";
  pyproject = false;

  disabled = pythonOlder "3.9";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    echo 'VALUE = "sample"' > $out/${python.sitePackages}/sample_python_package.py

    runHook postInstall
  '';

  pythonImportsCheck = [ "sample_python_package" ];

  meta = {
    description = "Placeholder Python package for this package set";
    license = lib.licenses.mit;
  };
}

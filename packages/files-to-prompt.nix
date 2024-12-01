{ lib
, fetchFromGitHub
, python3
, click
,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "files-to-prompt";
  version = "0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-gl3j0ok/hlFfIF3HhhzYrUZuNlAtU7y+Ej29sQv9tP4=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.click
  ];

  pythonImportsCheck = [ "files_to_prompt" ];

  meta = with lib; {
    description = "Concatenate a directory full of files into a single prompt for use with LLMs";
    homepage = "https://github.com/simonw/files-to-prompt";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
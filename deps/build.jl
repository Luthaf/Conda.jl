using Compat

module DefaultDeps
    if isfile("deps.jl")
        include("deps.jl")
    else
        const ROOTENV = abspath(dirname(@__FILE__), "usr")
        const MINICONDA_VERSION = "2"
    end
end

ROOTENV = get(ENV, "CONDA_JL_HOME", DefaultDeps.ROOTENV)
MINICONDA_VERSION = get(ENV, "CONDA_JL_VERSION", DefaultDeps.MINICONDA_VERSION)

if isdir(ROOTENV) && MINICONDA_VERSION != DefaultDeps.MINICONDA_VERSION
    error("""Miniconda version changed, since last build.
However, a root enviroment already exists at $(ROOTENV).
Setting Miniconda version is not supported for existing root enviroments.
To leave Miniconda version as, it is unset the CONDA_JL_VERSION enviroment variable and rebuild.
To change Miniconda version, you must delete the root enviroment and rebuild.
WARNING: deleting the root enviroment will delete all the packages in it.
This will break many Julia packages that have used Conda to install their dependancies.
These will require rebuilding.
""")
end

if !isdir(ROOTENV)
    # Ensure ROOTENV exists, otherwise prefix(ROOTENV) will throw
    mkpath(ROOTENV)
end

write("deps.jl", """
const ROOTENV = "$(escape_string(ROOTENV))"
const MINICONDA_VERSION = "$(escape_string(MINICONDA_VERSION))"
""")

# Pin npm packages by running ./bin/importmap

pin "application"

pin "chartmodules", preload: false
pin "chartkick", to: "chartkick.js", preload: false
pin "Chart.bundle", to: "Chart.bundle.js", preload: false

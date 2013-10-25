{exec} = require 'child_process'
task 'compilePublic', 'Compiles publicsrc', ->
  exec 'coffee --compile --watch --output public/ publicsrc/', (err, stdout, stderr) ->
    throw err if err
      console.log stdout + stderr
task 'compileSrc', 'Compiles src to web', ->
  exec 'coffee --compile --watch --output web/ src/', (err, stdout, stderr) ->
    throw err if err
      console.log stdout + stderr

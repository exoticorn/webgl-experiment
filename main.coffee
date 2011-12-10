canvas = document.getElementById('screen')

try
  gl = canvas.getContext('experimental-webgl')
catch e

if !gl
  alert("Your browser doesn't support WebGL.")

compile_shader = (source, type) ->
  shader = gl.createShader(type)
  gl.shaderSource(shader, source)
  gl.compileShader(shader)
  if !gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    alert(gl.getShaderInfoLog(shader))
    return null
  return shader

compile_program = (vertex, fragment) ->
  vertex = compile_shader(vertex, gl.VERTEX_SHADER)
  fragment = compile_shader(fragment, gl.FRAGMENT_SHADER)
  program = gl.createProgram()
  gl.attachShader(program, vertex)
  gl.attachShader(program, fragment)
  gl.linkProgram(program)
  if !gl.getProgramParameter(program, gl.LINK_STATUS)
    alert("Failed to link shaders")
  return program

vertex_shader = '''
attribute vec2 vertexPosition;
void main() {
  gl_Position = vec4(vertexPosition, 0, 1);
}
'''

fragment_shader = '''
precision mediump float;
void main() {
  gl_FragColor = vec4(1, 1, 1, 1);
}
'''

shader_program = compile_program(vertex_shader, fragment_shader)
shader_program.vertexPosition = gl.getAttribLocation(shader_program, "vertexPosition")

gl.clearColor(0, 0.25, 0, 1)
gl.viewport(0, 0, canvas.width, canvas.height)
gl.clear(gl.COLOR_BUFFER_BIT)

vertexBuffer = gl.createBuffer()
gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer)
vertices = [
  0.0, -1.0,
  1.0, 1.0,
  -1.0, 1.0
]
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)

gl.useProgram(shader_program)
gl.enableVertexAttribArray(shader_program.vertexPosition)
gl.vertexAttribPointer(shader_program.vertexPosition, 2, gl.FLOAT, false, 8, 0)
gl.drawArrays(gl.TRIANGLES, 0, 3)



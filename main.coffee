scene = new THREE.Scene()

camera = new THREE.PerspectiveCamera(25, window.innerWidth / window.innerHeight, 0.1, 1000)
width = 10
height = 10 * window.innerHeight / window.innerWidth
# camera = new THREE.OrthographicCamera( width / - 2, width / 2, height / 2, height / - 2, 1, 1000 )

controls = new THREE.TrackballControls( camera )
controls.rotateSpeed = 3
controls.noZoom = false
controls.noPan = true

camera.position.x = 10
camera.position.y = 10
camera.position.z = 10

renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

createCube = (size, r = 0, divs = 1) ->
	divs2 = divs * divs
	geometry = new THREE.BoxGeometry(size, size, size, divs, divs, divs)
	x_color = 0xf7c30f
	y_color = 0xe0a800
	z_color = 0xffec52

	for face, i in geometry.faces
		switch
			when 0 * divs2 <= i < 2 * divs2
				face.color.setHex(x_color)
			when 2 * divs2 <= i < 4 * divs2
				face.color.setHex(z_color)
			when 4 * divs2 <= i < 8 * divs2
				face.color.setHex(y_color)
			when 8 * divs2 <= i < 10 * divs2
				face.color.setHex(z_color)
			when 10 * divs2 <= i < 12 * divs2
				face.color.setHex(x_color)

	geometry.faces = geometry.faces.filter (face) ->
		vertices = [geometry.vertices[face.a], geometry.vertices[face.b], geometry.vertices[face.c]]
		not vertices.every((v) -> v.x >= 0 and v.y >= 0 and v.z >= 0)
	
	findVertex = (x, y, z) ->
		E = 0.001
		for v, i in geometry.vertices when -E < x - v.x < E and -E < y - v.y < E and -E < z - v.z < E
			return i
		return -1

	a = findVertex(size / 2, size / 2, size / 2)
	geometry.vertices[a].x = size * r
	geometry.vertices[a].y = size * r
	geometry.vertices[a].z = size * r
	b = findVertex(size / 2, 0, 0)
	geometry.vertices[b].y = size * r
	geometry.vertices[b].z = size * r
	c = findVertex(size / 2, size / 2, 0)
	geometry.vertices[c].z = size * r
	d = findVertex(0, size / 2, 0)
	geometry.vertices[d].x = size * r
	geometry.vertices[d].z = size * r
	e = findVertex(0, size / 2, size / 2)
	geometry.vertices[e].x = size * r
	f = findVertex(0, 0, size / 2)
	geometry.vertices[f].x = size * r
	geometry.vertices[f].y = size * r
	g = findVertex(size / 2, 0, size / 2)
	geometry.vertices[g].y = size * r

	geometry.faces.push(new THREE.Face3(a, b, c, new THREE.Vector3(0, 0, 1), new THREE.Color(z_color)))
	geometry.faces.push(new THREE.Face3(a, c, d, new THREE.Vector3(0, 0, 1), new THREE.Color(z_color)))
	geometry.faces.push(new THREE.Face3(a, d, e, new THREE.Vector3(1, 0, 0), new THREE.Color(x_color)))
	geometry.faces.push(new THREE.Face3(a, e, f, new THREE.Vector3(1, 0, 0), new THREE.Color(x_color)))
	geometry.faces.push(new THREE.Face3(a, f, g, new THREE.Vector3(0, 1, 0), new THREE.Color(y_color)))
	geometry.faces.push(new THREE.Face3(a, g, b, new THREE.Vector3(0, 1, 0), new THREE.Color(y_color)))

	material = new THREE.MeshLambertMaterial( { color: 0xffffff, wireframe: false, vertexColors: THREE.FaceColors } )
	return new THREE.Mesh(geometry, material)

light = new THREE.AmbientLight(0xffffff)
scene.add(light)

variation2 = ->
	cube1 = createCube(1, -0.1, 2)
	scene.add(cube1)

	cube2 = createCube(1, -0.1, 2)
	cube2.rotation.x = Math.PI
	cube2.rotation.y = -Math.PI / 2
	cube2.position.x = 1
	cube2.position.y = 1
	cube2.position.z = 1
	cube2.scale.x = 0.4
	cube2.scale.y = 0.4
	cube2.scale.z = 0.4

	cube3 = cube2.clone()
	cube4 = cube2.clone()
	cube5 = cube2.clone()
	cube6 = cube2.clone()

	cube1.add(cube2)
	cube2.add(cube3)
	cube3.add(cube4)
	cube4.add(cube5)
	cube5.add(cube6)

variation2()

variation1 = ->
	scene.add(createCube(1))

	mediumCube = createCube(0.6)
	mediumCube.rotateOnAxis(new THREE.Vector3(1,1,1).normalize(), 3 * Math.PI / 3)

	mediumCube.position.x = 0.8
	mediumCube.position.y = 0.8
	mediumCube.position.z = 0.8
	scene.add(mediumCube)

	smallCube = createCube(0.4)
	smallCube.position.x = 1.3
	smallCube.position.y = 1.3
	smallCube.position.z = 1.3
	scene.add(smallCube)

render = (t) ->
	controls.update()
	requestAnimationFrame(render)
	renderer.render(scene, camera)
requestAnimationFrame(render)

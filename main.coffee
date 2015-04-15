scene = new THREE.Scene()

camera = new THREE.PerspectiveCamera(25, window.innerWidth / window.innerHeight, 0.1, 1000)
width = 10
height = 10 * window.innerHeight / window.innerWidth
camera = new THREE.OrthographicCamera( width / - 2, width / 2, height / 2, height / - 2, 1, 1000 )

controls = new THREE.TrackballControls( camera )
controls.rotateSpeed = 3
controls.noZoom = true
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
			when 0 * divs2 <= i < 4 * divs2
				face.color.setHex(x_color)
			when 4 * divs2 <= i < 8 * divs2
				face.color.setHex(y_color)
			when 8 * divs2 <= i < 12 * divs2
				face.color.setHex(z_color)

	geometry.vertices[0].x -= size * r
	geometry.vertices[0].y -= size * r
	geometry.vertices[0].z -= size * r

	material = new THREE.MeshLambertMaterial( { color: 0xffffff, vertexColors: THREE.FaceColors } )
	return new THREE.Mesh(geometry, material)

light = new THREE.AmbientLight(0xffffff)
scene.add(light)

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

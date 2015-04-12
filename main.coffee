scene = new THREE.Scene()

camera = new THREE.PerspectiveCamera(25, window.innerWidth / window.innerHeight, 0.1, 1000)
width = 10
height = 10 * window.innerHeight / window.innerWidth
camera = new THREE.OrthographicCamera( width / - 2, width / 2, height / 2, height / - 2, 1, 1000 )

controls = new THREE.TrackballControls( camera )
controls.rotateSpeed = 5
controls.noZoom = true
controls.noPan = true
controls.dynamicDampingFactor = 0.1

camera.position.x = 10
camera.position.y = 10
camera.position.z = 10

renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)


createCube = (size) ->
	geometry = new THREE.BoxGeometry(size, size, size)
	x_color = 0xf7c30f
	y_color = 0xe0a800
	z_color = 0xffec52

	for face, i in geometry.faces
		switch
			when 0 <= i < 4
				face.color.setHex(x_color)
			when 4 <= i < 8
				face.color.setHex(y_color)
			when 8 <= i < 12
				face.color.setHex(z_color)
	material = new THREE.MeshBasicMaterial( { color: 0xffffff, vertexColors: THREE.FaceColors })
	cube = new THREE.Mesh(geometry, material)
	return cube

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

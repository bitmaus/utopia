
import Foundation
import GLKit
//import OpenGLES
import SceneKit
import AssetsLibrary
import ModelIO
import SceneKit.ModelIO

class GameViewController: UIViewController {
    @IBOutlet weak var scnView: SCNView?
        //self.transitioningDelegate = self.transitions
        //sender.destination.transitioningDelegate = self.transitions
        //let storyboard = UIStoryboard(name: "ControlPanel", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ControlPanelStart") as UIViewController
        //self.present(sender.destination, animated: true, completion: nil)
    
    //var scnView: SCNView!
    //var scnScene: SCNScene!
    let scene = SCNScene()
    
    override func viewDidLoad() {
        
        setupView()
        //let scene = SCNScene(MDLAsset: asset)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
        //geometryLabel.text = "Atoms\n"
        //geometryNode = Atoms.allAtoms()
        //scnView.scene!.rootNode.addChildNode(geometryNode)
    }
    
    func setupView() {
        setupScene()
        scnView?.scene = scene
        scnView = self.view as? SCNView
        
        scnView?.autoenablesDefaultLighting = true
        scnView?.allowsCameraControl = true
        //sceneView.scene = scene
        scnView?.backgroundColor = UIColor.gray
    }
    
    func setupScene() {
        
        let bundle = Bundle.main
        _ = bundle.path(forResource: "HourGlass", ofType: "obj")
        //let url = NSURL(fileURLWithPath: path!)
        //let asset = MDLAsset(url: url as URL)
        
        //guard let object = asset.object(at: 0) as? MDLMesh else {
          //  fatalError("Failed to get mesh from asset.")
        //}
        //let url = Bundle.main.url(forResource: "HourGlass", withExtension: "obj")
        let url = Bundle.init(path: "../../../../test.bundle")?.url(forResource: "HourGlass", withExtension: "obj")
        
        //let url = NSURL(string: "HourGlass")
        let asset = MDLAsset(url: url! as URL)
        let object = asset.object(at: 0)
        let node = SCNNode(mdlObject: object)
    
        let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
        let boxNode = SCNNode(geometry: boxGeometry)
        scene.rootNode.addChildNode(boxNode)
        //let node = SCNNode(MDLObject: object)
        scene.rootNode.addChildNode(node)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
    }
}


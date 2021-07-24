import Cocoa

var backImage:NSImage! = nil

let Numbars:Int = 32 // 64
let MinBarHeight:Float = 0
let MaxBarHeight:Float = 100

var bars:[Float] = Array(repeating:Float(), count: Numbars) // FFT data

class ViewController: NSViewController {
    
    @IBOutlet var background: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // replace image with all gradient bars drawn at 100% height
        let bundle = Bundle(for: ViewController.self)
        let url = bundle.url(forResource: "background", withExtension: "png")
        backImage = NSImage(contentsOf: url!)
        
        for i in 0 ..< Numbars { bars[i] = 50 }  // initial fake FFT data
        
        Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(timerHandler), userInfo: nil, repeats:true)
    }
    
    @objc func timerHandler() {
        
        // update bar heights from FFT data
        for i in 0 ..< Numbars {
            bars[i] += Float.random(in: -6 ... 6)
            if bars[i] < MinBarHeight { bars[i] = MinBarHeight } else if bars[i] > MaxBarHeight { bars[i] = MaxBarHeight }
        }
        
        // update barchart display
        background.setNeedsDisplay(background.bounds)
    }
}

class BaseNSView: NSView {
    override var isFlipped: Bool { return true }
    override var acceptsFirstResponder: Bool { return true }
    
    override func draw(_ rect: NSRect) {
        let c = CGFloat(0.4)
        NSColor(red:c, green:c + 0.1, blue:c, alpha:1).set()
        NSBezierPath(rect:bounds).fill()
    }
}

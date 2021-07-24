import Cocoa

class Barcharts : NSView
{
    let barXhop:CGFloat = 3    // X distance bewteen bars
    var barWidth:CGFloat = 0   // calculated width of each bar
    var barHeight:CGFloat = 0  // height when at 100%
    let eraseColor:NSColor = .black
    
    override func draw(_ rect: CGRect) {
        backImage.draw(at: CGPoint.zero, from: self.bounds, operation: .overlay, fraction:1)  // erase previous session, draw all bars at 100%
        
        if barWidth < 1 {   // first time drawn. determine bar constants
            barWidth = (bounds.size.width - (CGFloat(Numbars + 1) * barXhop)) / CGFloat(Numbars)
            barHeight = bounds.size.height - 10
        }
        
        eraseColor.setFill()
        
        var barRect = CGRect(x:barXhop, y:0, width:barWidth, height:barHeight)
        
        for i in 0 ..< Numbars {
            barRect.size.height = barHeight * CGFloat(bars[i]) / CGFloat(100)
            
            NSBezierPath(rect:barRect).fill()
            
            barRect.origin.x += barWidth + barXhop
        }
    }
    
    override var isFlipped: Bool { return true }
}

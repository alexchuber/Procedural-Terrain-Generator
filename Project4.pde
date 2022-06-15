import controlP5.*;

ControlP5 cp5;
Camera camera;
Terrain terrain;

void setup() {
  size(1200, 800, P3D);
  perspective(radians(90), (float)width/height, 0.1, 1000);
  cp5 = new ControlP5(this);
  terrain = new Terrain();
  camera = new Camera();
  SetupUI();
}

void draw()
{
  background(0);
  camera.Update();
  terrain.Draw();
  camera();
  perspective();
}


//==================================//
//===========UI CREATION============//
//==================================//

public void SetupUI()
{
  cp5.addSlider("SetRows")
    .setPosition(10, 10)
    .setSize(150, 15)
    .setValue(DEF_ROWS)
    .setRange(1, 100)
    .getCaptionLabel()
    .setSize(12)
    .setText("Rows");
  
  cp5.addSlider("SetCols")
    .setPosition(10, 35)
    .setSize(150, 15)
    .setValue(DEF_COLS)
    .setRange(1, 100)
    .getCaptionLabel()
    .setSize(12)
    .setText("Columns");
  
  cp5.addSlider("SetGridSize")
    .setPosition(10, 60)
    .setSize(150, 15)
    .setValue(DEF_SIZE)
    .setRange(20.0f, 50.0f)
    .getCaptionLabel()
    .setSize(12)
    .setText("Terrain Size");
  
  cp5.addButton("Generate")
    .setPosition(10, 100)
    .setSize(90,30)
    .getCaptionLabel()
    .setSize(12);
  
  cp5.addTextfield("SetFile")
    .setPosition(10, 145)
    .setSize(225,25)
    .setValue("terrain1")
    .setAutoClear(false)
    .getCaptionLabel()
    .setSize(12)
    .setText("Load From File");
    
  cp5.addToggle("ToggleStroke")
    .setPosition(300, 10)
    .setSize(50,25)
    .setValue(DEF_STROKE)
    .getCaptionLabel()
    .setSize(12)
    .setText("Stroke");
    
  cp5.addToggle("ToggleColor")
    .setPosition(365, 10)
    .setSize(50,25)
    .setValue(DEF_COLOR)
    .getCaptionLabel()
    .setSize(12)
    .setText("Color");
    
  cp5.addToggle("ToggleBlend")
    .setPosition(430, 10)
    .setSize(50,25)
    .setValue(DEF_BLEND)
    .getCaptionLabel()
    .setSize(12)
    .setText("Blend");
 
  cp5.addSlider("SetHeightMod")
    .setPosition(300, 60)
    .setSize(150, 15)
    .setValue(DEF_HEIGHT)
    .setRange(-5.0f, 5.0f)
    .getCaptionLabel()
    .setSize(12)
    .setText("Height Modifier");  
    
  cp5.addSlider("SetSnowMod")
    .setPosition(300, 85)
    .setSize(150, 15)
    .setValue(DEF_SNOW)
    .setRange(1.0f, 5.0f)
    .getCaptionLabel()
    .setSize(12)
    .setText("Snow Threshold");
}


//==================================//
//=========CONTROL HANDLERS=========//
//==================================//

public void Generate()
{
  terrain.Generate();
}

public void SetRows(int r)
{
  terrain.SetRows(r);
}

public void SetCols(int c)
{
  terrain.SetCols(c);
}

public void SetGridSize(float s)
{
  terrain.SetGridSize(s);
}

public void SetFile(String f)
{
  terrain.SetFile(f);
}

public void ToggleStroke(boolean t)
{
  terrain.ToggleStroke(t);
}

public void ToggleColor(boolean t)
{
  terrain.ToggleColor(t);
}

public void ToggleBlend(boolean t)
{
  terrain.ToggleBlend(t);
}

public void SetHeightMod(float h)
{
  terrain.SetHeightMod(h);
}

public void SetSnowMod(float s)
{
  terrain.SetSnowMod(s);
}


//==================================//
//==========INPUT HANDLERS==========//
//==================================//

void mouseWheel(MouseEvent event)
{
  float ticks = event.getCount();
  camera.Zoom(ticks);
}

void mouseDragged()
{
  if(!cp5.isMouseOver())
    camera.Move();
}

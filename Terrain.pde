//==================================//
//==============GLOBALS=============//
//==================================//

int DEF_ROWS = 10;
int DEF_COLS = 10;                           //Is this even "good practice"?
float DEF_SIZE = 30.0f;
String DEF_FILE = "terrain1";
boolean DEF_STROKE = true;
boolean DEF_COLOR = false;
boolean DEF_BLEND = false;
float DEF_HEIGHT = 1.0f;
float DEF_SNOW = 5.0f;

color SNOW = color(255,255,255);
color ROCK = color(135,135,135);
color GRASS = color(143, 170, 64);
color DIRT = color(160,128,84);
color WATER = color(0,75,200);



class Terrain
{
  
  //==================================//
  //========DATA & CONSTRUCTOR========//
  //==================================//
  
  //Data
  int rows, cols;
  float gridsize, heightmod, snowmod;
  boolean hasHeightMap, hasStroke, hasColor, hasBlend;
  ArrayList<PVector> vertices;
  ArrayList<Integer> vertexindices;
  PImage heightmap;
  
  //Constructor
  Terrain()
  {
    rows = DEF_ROWS;
    cols = DEF_COLS;
    gridsize = DEF_SIZE;
    heightmap = loadImage(DEF_FILE+".png");
    heightmod = DEF_HEIGHT;
    snowmod = DEF_SNOW;
    
    hasHeightMap = false;
    hasStroke = DEF_STROKE;
    hasColor = DEF_COLOR;
    hasBlend = DEF_BLEND;
    
    vertices = new ArrayList<PVector>();
    vertexindices = new ArrayList<Integer>();
    Generate();
  }
  
  
  //==================================//
  //=============MUTATORS=============//
  //==================================//
  
  //Generates grid vertices based on class' rows & cols
  void Generate()
  {
    vertices.clear();
    float quadwidth = gridsize / (float)cols;
    float quadheight = gridsize / (float)rows;
    for(int r = 0; r <= rows; r++)
    {
      for(int c = 0; c <= cols; c++)
      {
        float z = (-gridsize / 2.0f) + ((float)c * quadwidth);
        float x = (-gridsize / 2.0f) + ((float)r * quadheight);
        vertices.add(new PVector(z, 0, x));
      }
    }
    
    vertexindices.clear();
    for(int r = 0; r < rows; r++)
    {
      for(int c = 0; c < cols; c++)
      {
         int first = (r * (cols+1)) + c;
         vertexindices.add(first);
         int second = first + 1;
         vertexindices.add(second);
         int third = first + (cols+1);
         vertexindices.add(third);
         
         int fourth = first + 1;
         vertexindices.add(fourth);
         int fifth = first + (cols+1) + 1;
         vertexindices.add(fifth);
         int sixth = first + (cols+1);
         vertexindices.add(sixth);
      }
    }
    
    if(hasHeightMap)
      MapHeight();
  }
  
  //Maps vertices to heightmap
  void MapHeight()
  {
    for(int r = 0; r <= rows; r++)
    {
      for(int c = 0; c <= cols; c++)
      {
        float x = map(c, 0, cols+1, 0, heightmap.width);
        float y = map(r, 0, rows+1, 0, heightmap.height);
        color pixel = heightmap.get((int)x,(int)y);
        
        float heightfromcolor = map(red(pixel), 0, 255, 0, 1.0f); 
        
        int vertindex = (r * (cols+1)) + c;
        vertices.get(vertindex).y = heightfromcolor;
      }
    }
  }
  
  //SetRow handler
  void SetRows(int r)            //I only make these handlers because I *think* they're
  {                              //good practice? Are they though? It's so redundant :,)
    rows = r;
  }
  
  //SetCols handler
  void SetCols(int c)
  {
    cols = c;
  }
  
  //SetGridSize handler
  void SetGridSize(float s)
  {
    gridsize = s;
  }
  
  //SetFile handler
  void SetFile(String f)
  {
    if(f.equals(""))
    {
      hasHeightMap = false;
    }
    else
    {
      hasHeightMap = true;
      heightmap = loadImage(f+".png");  
    }  
    Generate();
  }
  
  //ToggleStroke handler
  void ToggleStroke(boolean t)
  {
    hasStroke = t;
  }
  
  //ToggleColor handler
  void ToggleColor(boolean t)
  {
    hasColor = t;
  }
  
  //ToggleBlend handler
  void ToggleBlend(boolean t)
  {
    hasBlend = t;
  }
  
  //SetHeightMod handler
  void SetHeightMod(float h)
  {
    heightmod = h;
  }
  
  //SetSnowMod handler
  void SetSnowMod(float s)
  {
    snowmod = s;
  }
  
  
  //==================================//
  //============BEHAVIORS=============//
  //==================================//
  
  //Draws the grid with its appropriate colors; called each frame
  void Draw()
  {
    noStroke();
    if(hasStroke)
      stroke(5);

    beginShape(TRIANGLES);
    for(int i = 0; i < vertexindices.size(); i++)
    {
      int vertindex = vertexindices.get(i);
      PVector vertex = vertices.get(vertindex);
      
      float relativeheight = abs(vertex.y) * heightmod / snowmod;
      color vertcolor = CalculateColor(relativeheight);

      fill(vertcolor);      
      vertex(vertex.x, (-vertex.y*heightmod), vertex.z);
    }
    endShape();
  }


  //==================================//
  //=============HELPERS==============//
  //==================================//
  
  //Returns vertex color based on relativeheight parameter
  color CalculateColor(float rh)
  {
      color vertcolor = color(255,255,255);
 
      if(hasColor)
      {
        if(rh >= 0.8f)
        {
          vertcolor = SNOW;
          if(hasBlend)
          {
            float ratio = (rh - 0.8f) / 0.2f;
            vertcolor = lerpColor(ROCK, SNOW, ratio);
          }
        }
        else if(rh >= 0.4f)
        {
          vertcolor = ROCK;
          if(hasBlend)
          {
            float ratio = (rh - 0.4f) / 0.4f;
            vertcolor = lerpColor(GRASS, ROCK, ratio);
          }
        }
        else if(rh >= 0.2f)
        {
          vertcolor = GRASS;
          if(hasBlend)
          {
            float ratio = (rh - 0.2f) / 0.2f;
            vertcolor = lerpColor(DIRT, GRASS, ratio);
          }
        }
        else
        {
          vertcolor = WATER;
          if(hasBlend)
          {
            float ratio = rh / 0.2f;
            vertcolor = lerpColor(WATER, DIRT, ratio);
          }
        }
      }
      
      return vertcolor;
  }
  
};

//introduce variables and objects
PImage mapImage;
Table locationTable; //this is using the Table object
Table amountsTable; //this is using the Table object
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
color c= color(255,0,0);
//global variables assigned values in drawData()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

float minusrad;
float moreopa;


void setup() {
  size(900, 830);
  mapImage = loadImage("SFMap1.png");

  //assign tables to object
  locationTable = new Table("locations.tsv");  
  amountsTable = new Table("amounts.tsv");

  // get number of rows and store in a variable called rowCount
  rowCount = locationTable.getRowCount();
  //count through rows to find max and min values in random.tsv and store values in variables
  for (int row = 1; row< rowCount; row++) {
    //get the value of the second field in each row (1)
    float value = amountsTable.getFloat(row, 0);
    //if the highest # in the table is higher than what is stored in the 
    //dataMax variable, set value = dataMax
    if (value>dataMax) {
      dataMax = value;
    }
    //same for dataMin
    if (value<dataMin) {
      dataMin = value;
    }
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);
  //just a filter for the image to make it darker
    fill(0,0,0,75);
    rect(0,0,1000,1000);

  closestDist = MAX_FLOAT;

//count through rows of location table, 
  for (int row = 0; row<rowCount; row++) {
    //assign id values to variable called id
    String id = amountsTable.getRowName(row);
    //get the 2nd and 3rd fields and assign them to
    float x = locationTable.getFloat(id, 1);
    float y = locationTable.getFloat(id, 2);
    //use the drawData function (written below) to position and visualize
       
    drawData(x, y, id);
  }

//if the closestDist variable does not equal the maximum float variable....
  if (closestDist != MAX_FLOAT) {
    fill(0);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
  }
}

//we write this function to visualize our data 
// it takes 3 arguments: x, y and id
void drawData(float x, float y, String id) {
//value variable equals second field in row
  float value = amountsTable.getFloat(id, 1);
  float radius = 0;
//if the value variable holds a float greater than or equal to 0
  if (value>=15) {
    //remap the value to a range between 1.5 and 15
    radius = map(value, 21, dataMax/3, 20, 50); 
    //and make it this color
    
    strokeWeight(0);
  } else {
    //otherwise, if the number is negative, make it this color.
    radius = map(value, 12, dataMax/3, 20, 50);   
    strokeWeight(0);
  }
  //make a circle at the x and y locations using the radius values assigned above

  fill(c);
  ellipseMode(RADIUS);
  ellipse(x, y, radius, radius);

  float d = dist(x, y, mouseX, mouseY);

println(d);

//if the mouse is hovering over circle, show information as text
  if ((d<radius+2) && (d<closestDist)) {
    closestDist = d;
    String name = amountsTable.getString(id, 1);
    closestText = name +" "+value;
    closestTextX = x;
    closestTextY = y-radius-4;
    
    //minusrad = -20;
    //moreopa = 250;
    fill(0,255,0);
    ellipseMode(RADIUS);
    ellipse(x, y, radius+20, radius+20);
  }
    else {
      minusrad = 0;
      moreopa = 0;
  }
}
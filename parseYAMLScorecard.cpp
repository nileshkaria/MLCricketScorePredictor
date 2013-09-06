#include <iostream>
#include <fstream>
#include <sstream>
#include <stack>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;

class YAMLParser
{
public:
  YAMLParser();
  ~YAMLParser();

  void readFile(const string &rLocation);

private:
  YAMLParser(const YAMLParser&);
  YAMLParser operator=(const YAMLParser&);
};

YAMLParser::YAMLParser() {}
YAMLParser::~YAMLParser() {}

void YAMLParser::readFile(const string &rLocation)
{
  ifstream ifs(rLocation.c_str());

  if(ifs.is_open())
  {
    bool innings(false), output(false), fallOfWicket(false);
    int wicket(10), total(0), extras(0), balls(0), num(0), partnership(0);

    string line;

    size_t s(rLocation.size());

    string file1(rLocation.substr(0, s - 5) + "_1.txt"), file2(rLocation.substr(0, s - 5) + "_2.txt");

    ofstream ofs1(file1.c_str()), ofs2(file2.c_str());
    
    while(ifs.good() && ofs1.good() && ofs2.good())
    {
      getline(ifs, line);

      if(!innings && line.find(" innings:") != string::npos)
	innings = true;

      if(innings)
      {
	if(line.find("runs:") != string::npos)
	  output = true;
	else if(line.find(".") != string::npos)
	{
	  if(fallOfWicket)
	  {
	    partnership = 0;
	    fallOfWicket = false;
	  }

	  if(output)
	  {
	    if(num == 1)
	      ofs1 << "," << wicket << "," << partnership << "," << total;
	    else
	      ofs2 << "," << wicket << "," << partnership << "," << total;

	    output = false;
	  }

	  if(line.find("- 0.1") != string::npos)
	  {
	    balls = extras = total = partnership = 0;
	    wicket = 10;
	    ++num;
	    //ofs1 << endl << " [ " << rLocation.substr(0, rLocation.find(".")) << "_" << ++num << " ] ";
	  }

	  if(num == 1)
	    ofs1 << endl << ++balls;
	  else
	    ofs2 << endl << ++balls;
	}
	else if(output)
	{
	  size_t pos = line.find("total: ");

	  if(pos != string::npos)
	  {
	    istringstream iss(line.substr(pos + 7));
	    int temp;
	    iss >> temp;

	    total       += temp;
	    partnership += temp;
	    
	    if(num == 1)
	      ofs1 << "," << static_cast<double>(total)*6.0/static_cast<double>(balls);
	    else
	      ofs2 << "," << static_cast<double>(total)*6.0/static_cast<double>(balls);
	  }
	  else
	  {
	    pos = line.find("extras:");

	    if(pos != string::npos)
	    {
	      istringstream iss(line.substr(pos + 8));
	      int temp;
	      iss >> temp;
	      
	      extras += temp;

	      if(num == 1)
		ofs1 << "," << extras;
	      else
		ofs2 << "," << extras;
	    }
	    else if(line.find("wicket:") != string::npos)
	    {
	      --wicket;
	      fallOfWicket = true;
	    }
	  }
	}
      }
    }

    //@TODO - Test this line of code
    if(fallOfWicket)
      partnership = 0;
    
    ofs2 << "," << wicket << "," << partnership << "," << total << endl;

    ofs1.close();
    ofs2.close();
  }
  else
    cerr << "Unable to open file [" << rLocation << "]" << endl;
}


int main(int argc, char ** argv)
{
  if(argc != 2)
  {
    cerr << "Usage: parseYAMLScorecard file.txt" << endl;
    return 1;
  }

  YAMLParser y;

  y.readFile(argv[1]);

  return 0;
}

version(prob00)
{
	import std.stdio;

	void main()
	{
		writeln("Go Rams Go!");
	}
}

version(prob01)
{
	import std.stdio, std.string;

	void main()
	{
		string name = readln().stripRight;
		writeln("oh all powerful judge " ~ name ~ " please give us the points.");
	}
}

version(prob02)
{
	import std.stdio;
	import std.conv: text;

	void main()
	{
		int m, v;
		readf!"%d %d\n"(m, v);
		writeln(text!int(m * v));
	}
}

version(prob03)
{
	import std.stdio, std.string;
	import std.conv: text, to;
	//using format to retain floating point precision. writeln wants to limit it
	import std.format;

	void main()
	{
		string[] results;
		foreach (x; 0..3) results ~= format!"%f"(to!double(readln().stripRight) * 0.299792);
		foreach(d; results) writeln(d);
	}
}

version(prob04)
{
	import std.stdio, std.string;
	import std.conv: text, to;
	import std.format;

	void main()
	{
		uint n = to!uint(readln().stripRight);
		string[] results;
		foreach(x; 0..n)
		{
			double a, b;
			readf!"%f %f\n"(a, b);
			results ~= format!"%f"(a / (b / 60));
		}
		foreach (d; results) writeln(d);
	}
}

version(prob05)
{
	import std.stdio, std.string;
	import std.conv: text, to;
	import std.format, std.typecons;

	void main()
	{
		uint n = to!uint(readln().stripRight);
		Tuple!(string, double)[] times;
		foreach(z; 0..n)
		{
			string name;
			double a, b;
			readf!"%s %f %f\n"(name, a, b);
			times ~= tuple(name, a/b);
		}
		//get lowest time
		Tuple!(string, double) lowest = times[0];
		foreach(t; times[1..$])
		{
			if (t[1] < lowest[1])
				lowest = t;
		}
		writeln(lowest[0] ~ " " ~ text!double(lowest[1]));
	}
}

version(prob06)
{
	import std.stdio, std.string;
	import std.conv: to, text;
	import std.algorithm, std.array;

	void main()
	{
		uint n = to!uint(readln().stripRight);
		string[] results;
		foreach(z; 0..n)
		{
			string input = readln().stripRight;
			//lol who needs to read the problem anyways
			int[] v = input.split(" ").map!(a => to!int(a)).array()[1..$];
			int[] d;
			foreach(i; 0..v.length-1)
				d ~=  -(v[i+1] - v[i]);
			foreach(i; 1..v.length)
				v[i] = v[i-1] + d[i-1];
			// writeln(v);
			string b;
			foreach(x; v)
			{
				b ~= text!int(x) ~ " ";
			}
			results ~= b;
		}
		foreach(s; results)
		{
			writeln(s);
		}
	}
}

version(prob07)
{
	import std.stdio, std.string;
	import std.conv: to, text;
	import std.format;
	import std.algorithm, std.array;
	import std.math;

	enum ITERATIONS = 100;

	//[n+1] = C + ( A * x[n] + M ) / ( B * x[n] + N )
	double iterate(double x0, int A, int B, int C, int M, int N, double e, uint iteration)
	{
		double xn1 = C + ( A * x0 + M ) / ( B * x0 + N );
		// writeln(xn1);
		if (iteration > ITERATIONS && abs(xn1 - x0) >= e)
			return -6969420.0;
		else if (abs(xn1 - x0) < e)
			return xn1;
		return iterate(xn1, A, B, C, M, N, e, iteration+1);
	}

	void main()
	{
		uint n = to!uint(readln().stripRight);
		double[] results;
		foreach(x; 0..n)
		{
			double x0, e;
			int A, B, C, M, N;
			readf!"%f %d %d %d %d %d %f\n"(x0, A, B, C, M, N, e);
			results ~= iterate(x0, A, B, C, M, N, e, 0);
		}
		foreach(s; results)
		{
			if (s == -6969420.0)
				writeln("DIVERGES");
			else
				writeln(s);
		}
	}
}

version(prob08)
{
	import std.stdio, std.string, std.math;

	string readBin(ulong num)
	{
		string bin;
		foreach(x; 0..ulong.sizeof*8)
			bin ~= (num >> x) & 1 ? "1" : "0";
		return bin;
	}

	int parity(ulong n)
	{
		// a more technical solution would be to use an actual parity generator
		// i.e.: B1^B2^B3^...^Bn 
		// parity is inversed also soooooo........not good solution
		return n.readBin.count("1") % 2 == 0 ? 1 : 0;
	}

	void main()
	{
		enum CHUNKSIZE = 4;
		ulong lower, upper;
		readf!"%u %u\n"(lower, upper);
		ulong[] answers;
		while (lower != 0 || upper != 0)
		{
			ulong lowerPatternStart = lower / CHUNKSIZE;
			ulong lowerPatternIndex = lower % CHUNKSIZE;
			ulong lowerPatternLast = CHUNKSIZE;
			if (upper < lowerPatternLast)
				lowerPatternLast = upper;

			ulong upperPatternStart = upper / CHUNKSIZE;
			ulong upperPatternIndex = upper % CHUNKSIZE;

			ulong parityAmount(ulong n, ulong start, ulong end)
			{
				ulong p;
				foreach(x;start..end+1)
				{
					p += parity(n+x-start);
				}
				return p;
			}

			ulong midAmount = upperPatternStart - (lowerPatternStart + (upper == lower ? 0 : 1));
			midAmount *= CHUNKSIZE;
			midAmount /= 2;
			if (upper != lower)
			{
				midAmount += parityAmount(lower, lowerPatternIndex, lowerPatternLast);
				midAmount += parityAmount(upper - upperPatternIndex, 0, upperPatternIndex);
			}
			else
				midAmount += parity(lower);

			answers ~= midAmount;

			readf!"%u %u\n"(lower, upper);
		}
		foreach(a; answers)
		{
			writeln(a);
		}
	}
}

version(prob09)
{
	import std.stdio;
	import std.typecons;

	// x, y, z
	alias Point = Tuple!(uint, "x", uint, "y", uint, "z", char, "c");

	class ConsoleBuffer(uint width, uint height)
	{
	public:
		this()
		{

		}
		void push(Point p)
		{
			if (!this.exists(p))
				points ~= p;
		}
		void draw()
		{
			foreach(p; points)
			{
				buffer[p.y][p.x] = p.c;
			}
			foreach(ln; buffer[][])
			{
				foreach(c; ln[])
				{
					write(c);
				}
				writeln();
			}
		}
	private:
		char[width][height] buffer;
		Point[] points;
		bool exists(Point a)
		{
			foreach(p; points)
			{
				if (p.x == a.x && p.y == a.y && p.z <= a.z)
					return true;
			}
			return false;
		}
	}

	void main()
	{
		uint center, width;
		readf!"%u %u\n"(center, width);
		auto buf = new ConsoleBuffer!(60, 12)();
		uint z = 0;
		while (center != 0 || width != 0)
		{
			int s = cast(int)width;
			uint height = 0;
			while (s >= 0)
			{
				foreach(x; center-s+1..center+s+1)
				{
					Point p;
					p.x = x;
					p.y = 11 - height;
					p.z = z;
					if (x == center-s+1 || x == center+s)
						p.c = x <= center ? '/' : '\\';
					else
						p.c = ' ';
					buf.push(p);
				}
				s -= 1;
				height++;
			}
			readf!"%u %u\n"(center, width);
			z++;
		}
		buf.draw;
		foreach(n; 0..6)
			write("0123456789");
		writeln();
	}
}

version(prob10)
{
	import std.stdio, std.string;
	import std.algorithm.mutation;

	bool palindrome(string s)
	{
		return s == s.dup.reverse;
	}

	string remove(string base, string match)
	{
		string tmp;
		foreach(c; base)
		{
			if (match.indexOf(c) < 0)
				tmp ~= c;
		}
		return tmp;
	}

	void main()
	{
		uint n;
		readf!"%d\n"(n);
		string[] longest;
		foreach(x;0..n)
		{
			string input = readln();
			string bs = "";
			uint bl = 0;
			foreach(z; 0..input.length)
			{
				foreach(y; z..input.length)
				{
					auto sanitized = remove(input[z..y], "\\',.'!? ").toLower;
					if (sanitized.palindrome && sanitized.strip.length > bl)
					{
						bl = sanitized.strip.length;
						bs = input[z..y];
					}
				}
			}
			if (bl == 1)
				longest ~= "NO PALINDROME";
			else
				longest ~= bs;
		}
		foreach(s; longest)
			writeln(s);
	}
}

version(prob11)
{
	import std.stdio;
	import std.string;
	import std.conv;
	import std.algorithm;
	import std.array;
	import std.range;

	uint[char] occuranceMap(string input)
	{
		uint[char] m;
		foreach(c; input)
			m[c]++;
		return m;
	}

	string remove(string base, string match)
	{
		string tmp;
		foreach(c; base)
			if (match.indexOf(c) < 0)
				tmp ~= c;
		return tmp;
	}

	void main()
	{
		string[] ln1 = readln().stripRight.split(" ");
		string[] ln2 = readln().stripRight.split(" ");

		uint rows = to!uint(ln1[0]);
		uint noise = to!uint(ln1[2]);
		uint words = to!uint(ln2[0]);
		uint[] wordSizes = ln2[1..$].map!(a => to!uint(a)).array();

		writeln("rows: ", rows);
		writeln("noise: ", noise);
		writeln("words: ", words);
		writeln("word sizes: ", wordSizes);

		string lines;
		foreach(x; iota(rows))
		{
			lines ~= readln().stripRight; //remove newline
		}
		//remove spaces
		lines.remove(" ");
		//generate a map
		auto occurances = occuranceMap(lines);
		writeln("occurance map: ", occurances);
		string f;
		uint n;
		uint word;
		foreach(c; lines)
		{
			if (occurances[c] < noise)
			{
				f ~= c;
				writeln(wordSizes[word]);
				if (n++ == wordSizes[word] - 1)
				{
					f~= " ";
					word++;
					n = 0;
				}
			}
		}
		writeln(f);
	}
}

version(prob12)
{
	import std.stdio;
	import std.range;
	import std.conv;
	import std.array;
	import std.string;
	import std.algorithm;

	uint pairs(uint tutor, uint[] tutees)
	{
		uint c;
		foreach(s; tutees)
			if (s < tutor)
				c++;
		return c;
	}

	void main()
	{
		uint sets;
		readf!"%u\n"(sets);
		uint[] answers;
		foreach(s; iota(sets))
		{
			// if this isn't a reason to use D i don't know what is
			uint[] tutors = readln().stripRight.split(" ")[1..$].map!(a => to!uint(a)).array();
			uint[] tutees = readln().stripRight.split(" ")[1..$].map!(a => to!uint(a)).array();
			uint combos;
			foreach(a; tutors)
				combos += pairs(a, tutees);
			answers ~= combos;
		}
		answers.each!(a=>writeln(a));
	}
}

version(prob13)
{
	import std.stdio;
	import std.typecons;
	import std.string;

	// x, y, z
	alias Point = Tuple!(uint, "x", uint, "y", uint, "z", char, "c");

	class ConsoleBuffer(uint width, uint height)
	{
	public:
		this()
		{

		}
		void push(Point p)
		{
			if (!this.exists(p))
				points ~= p;
		}
		void draw()
		{
			foreach(p; points)
			{
				buffer[p.y][p.x] = p.c;
			}
			foreach(ln; buffer[][])
			{
				foreach(c; ln[])
				{
					write(c);
				}
				writeln();
			}
		}
	private:
		char[width][height] buffer;
		Point[] points;
		bool exists(Point a)
		{
			foreach(p; points)
			{
				if (p.x == a.x && p.y == a.y && p.z <= a.z)
					return true;
			}
			return false;
		}
	}

	void main()
	{
		string text = readln().stripRight();
		// change the size if you want to make the buffer larger
		auto buf = new ConsoleBuffer!(60, 60)();
		Point p = Point(30, 30, 0, ' ');
		string dir = "r";
		foreach(c; text)
		{
			final switch (c)
			{
				case 'r': dir = "r"; break;
				case 'l': dir = "l"; break;
				case 'u': dir = "u"; break;
				case 'd': dir = "d"; break;
			}
			final switch (dir)
			{
				case "r": p.x++; break;
				case "l": p.x--; break;
				case "u": p.y--; break;
				case "d": p.y++; break;
			}
			p.c = c;
			buf.push(p);
		}
		buf.draw();
	}
}

version (prob14)
{
	// possible???
	// https://math.stackexchange.com/questions/636128/calculating-the-number-of-possible-paths-through-some-squares
	import std.stdio;
	import std.conv;
	import std.typecons;
	import std.array;
	import std.string;
	import std.algorithm;
	import std.range;

	alias Coord = Tuple!(uint, "x", uint, "y");

	uint solutions(string[] maze, Coord current, Coord end)
	{
		// writeln("x:\t", current.x, "\ty:\t", current.y);
		if (current.x > end.x || current.y > end.y)
			return 0;
		if (maze[current.y][current.x] == '#')
			return 0;
		if (current.x == end.x && current.y == end.y)
			return 1;
		return  solutions(maze, Coord(current.x+1, current.y), end) +
				solutions(maze, Coord(current.x, current.y+1), end);
	}

	void main()
	{
		uint[] size = readln().stripRight.split(" ").map!(a => to!uint(a)).array();
		Coord end;
		end.x = size[1]-1;
		end.y = size[0]-1;
		// writeln("Final Coordinates:\n", "X:\t", end.x, "\tY:\t", end.y);
		string[] maze;
		foreach(y; iota(end.y+1))
		{
			maze ~= readln().stripRight;
		}
		writeln(solutions(maze, Coord(0,0), end));
	}
}

// recursion and loops? yay!
version(prob15)
{
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.conv;
	import std.array;
	import std.range;
	import std.typecons;
	import std.math;

	immutable uint[] linear = [
		1,
		2,
		3,
		4,
		5,
		6
	];
	immutable uint[] fibonacci = [
		0,
		1,
		1,
		2,
		3,
		5
	];
	immutable uint[] tribonacci = [
		0,
		0,
		1,
		1,
		2,
		4
	];
	immutable uint[] normal = [
		1,
		2,
		2,
		3,
		3,
		4
	];
	immutable uint[] zipf = [
		1,
		1,
		1,
		2,
		2,
		3
	];
	immutable uint[] prime = [
		0,
		1,
		2,
		3,
		5,
		7
	];
	immutable uint[] gaussian = [
		1,
		2,
		3,
		3,
		4,
		5
	];

	auto getDie(string d)
	{
		final switch (d)
		{
			case "L": return linear;
			case "F": return fibonacci;
			case "T": return tribonacci;
			case "N": return normal;
			case "Z": return zipf;
			case "P": return prime;
			case "G": return gaussian;
		}
	}

	uint getN(string[] dice, uint target, uint levels, uint sum, uint depth)
	{
		// if we are at the last level and have the  correct sum
		if (sum == target && depth == levels + 1)
			return 1;
		// if we have gone too far
		else if (depth >= levels + 1)
			return 0;
		uint count;
		foreach(key; getDie(dice[depth]))
		{
			// add the key to the sum
			sum += key;
			// recursive call to next depth
			count += getN(dice, target, levels, sum, depth+1);
			// remove key from sum for next pass
			sum -= key;
		}
		return count;
	}

	void main()
	{	
		Tuple!(string[], uint[], uint[], uint)[] answers;
		string input = readln.stripRight;
		while (input != "X X X 0 0 0")
		{
			//get all the infos set up
			string[] dice = input.strip.split(" ")[0..3];
			uint[] sums = input.strip.split(" ")[3..$].map!(a => to!uint(a)).array();
			uint levels;
			foreach(c; dice)
				if (c != "X")
					levels++;
			uint[] counts;
			foreach(target; sums)
				counts ~= getN(dice, target, levels - 1, 0, 0);
			answers ~= tuple(dice, sums, counts, levels);
			input = readln().stripRight;
		}
		foreach(t; answers)
		{
			t[0].each!(a => write(a, " "));
			writeln();
			// lol, just this loop
			foreach(i; iota(t[1].length))
				write(t[1][i], "\t", t[2][i], "\t", cast(double)t[2][i] / cast(double)pow(6, t[3]) * 100.0, "%\n");
		}
	}
}

version(prob16)
{
	import std.stdio;
	import std.string;
	import std.typecons;
	import std.range;
	import std.algorithm;

	string remove(string base, string match)
	{
		string tmp;
		foreach(c; base)
			if (match.indexOf(c) < 0)
				tmp ~= c;
		return tmp;
	}

	uint[char] occuranceMap(string input)
	{
		uint[char] m;
		foreach(c; input)
			m[c]++;
		return m;
	}

	bool verify(string s0, string s1)
	{
		auto m1 = occuranceMap(s1);
		foreach(c; s0)
		{
			auto x = c in m1;
			if (x)
			{
				if (*x > 0)
					*x = *x - 1;
				else
					return false;
			}
			else
				return false;
		}
		return true;
	}

	bool solve(char[][] dice, uint numDice, string matchPhrase, string thisPhrase, uint thisDepth)
	{
		if (verify(matchPhrase, thisPhrase))
			return true;
		if (thisDepth > numDice)
			return false;
		// pull out our current row
		auto row = dice[thisDepth];
		foreach(i; iota(1, row.length+1))
		{
			// pull out current character
			char a = row[i-1];
			string tempPhrase = thisPhrase ~ a;
			if (solve(dice, numDice, matchPhrase, tempPhrase, thisDepth + 1))
				return true;
		}
		return false;
	}

	void main()
	{
		uint numCubes;
		readf!"%u\n"(numCubes);
		string[] cubes;
		foreach(x; iota(numCubes))
			cubes ~= remove(readln().stripRight, " ");
		uint numWords;
		readf!"%u\n"(numWords);
		Tuple!(string, bool)[] answers;
		foreach(x; iota(numWords))
		{
			string word = readln.stripRight;
			answers ~= tuple(word, solve(cast(char[][])cubes, numCubes-1, word, "", 0));
		}
		answers.each!(a => writeln(a[0], a[1] ? " can" : " CANNOT", " be formed"));
	}
}

version(prob17)
{
	import std.stdio;
	import std.typecons;
	import std.string;
	import std.range;

	string removeNot(string base, string match)
	{
		string tmp;
		foreach(c; base)
			if (match.indexOf(c) >= 0)
				tmp ~= c;
		return tmp;
	}
	alias Info = Tuple!(double, "value", bool, "repeatable", char, "subtractable");

	void main()
	{
		Info[char] numerals = [
			'S' : Info(0.5, false, cast(char)0),
			'I' : Info(1.0, true, cast(char)0),
			'V' : Info(5.0, false, 'I'),
			'X' : Info(10.0, true, 'I'),
			'L' : Info(50.0, false, 'X'),
			'C' : Info(100.0, true, 'X'),
			'D' : Info(500.0, false, 'C'),
			'M' : Info(1000.0, true, 'C')
		];

		double decode(string r)
		{
			// we need to preprocess the string to ensure some rules
			char p = r[0];
			uint streak;
			string[] sections = [[p]];
			foreach(c; r[1..$])
			{
				if (c != p)
				{
					streak = 0;
					sections ~= [c];
				}
				else
				{
					streak++;
					sections[$-1] ~= c;
				}
				// change 3 to 2 for 3 streak max... not sure which one it is apparently XIIII is 14 and so is XIV
				if (streak > 2)
					return 0;//invalid?: cannot have streak longer than 3 (maybe 4)
				if (c == p && !numerals[c].repeatable)
					return 0;//invalid: numeral is not repeatable
				if (numerals[p].value < numerals[c].value 
					&& numerals[c].subtractable != p)
					return 0; //invalid: subtracting invalid value
				p = c;
			}
			// for each section we create a sum
			double[] sums;
			foreach(s; sections)
				sums ~= (numerals[s[0]].value * cast(double)s.length);
			double sum = 0;
			for (int i = 0; i < sums.length; i++)
			{
				if (i+1 < sums.length)
				{
					// left > right
					if (sums[i] > sums[i+1])
					{
						sum += sums[i];
					}
					else // left < right
					{
						// cannot have a length > 1
						if (sections[i].length > 1)
							return 0;
						sum += sums[i+1] - sums[i];
						// since it was less we want to skip
						i++;
					}
				}
				else // last index
					sum += sums[i];
			}

			return sum;
		}

		string input = readln().stripRight;
		while (input != "0")
		{
			// remove non-roman numerals 
			input = input.toUpper.removeNot("IVXLCDMS");
			double largest = 0;
			foreach(x; input.length.iota)
			{
				foreach(y; iota(x, input.length))
				{
					auto v = decode(input[x..y+1]);
					if (v > largest)
					{
						// writeln("numeral:\t",input[x..y+1],"\tvalue:\t", v);
						largest = v;
					}
				}
			}
			writeln(largest);

			input = readln().stripRight;
		}
	}
}

version(prob18)
{
	import std.stdio;
	import std.string;
	import std.typecons;
	import std.range;

	alias Attack = Tuple!(string, "name", uint, "power", uint, "damage");
	alias Ponymon = Tuple!(string, "name", char, "type", char, "weakness", char, "resistance", uint, "hp",
							Attack, "attack1", Attack, "attack2");
	
	void main()
	{
		uint n;
		readf!"%u\n"(n);
		Ponymon[string] ponymon;
		foreach(x; iota(n))
		{
			Ponymon t;
			readf!"%s %c %c %c %u %s %u %u %s %u %u\n"(t.name, t.type, t.weakness, t.resistance, t.hp,
														t.attack1.name, t.attack1.power, t.attack1.damage,
														t.attack2.name, t.attack2.power, t.attack2.damage);
			ponymon[t.name] = t;
		}
		readf!"%u\n"(n);
		foreach(x; iota(n))
		{
			string[] contestants = readln.stripRight.split(" ");
			auto left = ponymon[contestants[0]];
			auto right = ponymon[contestants[1]];
			// name, hp, power
			Tuple!(string, int, uint) l = tuple(left.name, left.hp, 0);
			Tuple!(string, int, uint) r = tuple(right.name, right.hp, 0);

			void attack(ref Tuple!(string, int, uint) attacker, ref Tuple!(string, int, uint) victim)
			{
				// get optimal attack
				// we prioritize higher damage
				auto pm = ponymon[attacker[0]];
				auto vm = ponymon[victim[0]];
				double mod = 1;
				if (vm.weakness != 'X' && vm.weakness == pm.type)
					mod = 2;
				else if (vm.resistance != 'X' && vm.resistance == pm.type)
					mod = 0.5;

				if (attacker[2] >= pm.attack2.power)
				{
					victim[1] -= cast(uint)(cast(double)pm.attack2.damage * mod);
					// attacker[2] -= pm.attack2.power;
				}
				else if (attacker[2] >= pm.attack1.power)
				{
					victim[1] -= cast(uint)(cast(double)pm.attack1.damage * mod);
					// attacker[2] -= pm.attack1.power;
				}
			}

			// winner, hp
			Tuple!(string, int) simulate()
			{
				// writeln(l[0],":\t",l[1],"\t",r[0],":\t",r[1]);
				// increment their power
				l[2]++;
				r[2]++;
				attack(l, r);
				if (r[1] <= 0)
					return tuple(l[0], l[1]);
				attack(r, l);
				if (l[1] <= 0)
					return tuple(r[0], r[1]);
				return simulate();
			}

			auto winner = simulate();
			writeln("winner:\t",winner[0],"\thp:\t",winner[1]);
		}
	}
}

version(prob19)
{
	import std.stdio;
	import std.math;
	import std.range;
	import std.algorithm;
	import std.array;
	import std.string;
	import std.conv;

	double[] calibrate(ushort[][] known)
	{
		// 
		double kP(double sFar, double sNear, double vFar, double vNear)
		{
			return (sFar - sNear) / ((1/sqrt(vFar)) - (1/sqrt(vNear)));
		}
		double eP(double k, double v, double s)
		{
			return (k/sqrt(v)) - s;
		}
		// solve for k
		ubyte n;
		double E = 0.0;
		foreach(i; known.length.iota)
		{
			auto reading = known[i];
			// ushort s = reading[0];
			// ushort v = reading[1];
			foreach(j; known.length.iota)
			{
				//writeln(E);
				if (i != j)
				{
					auto check = known[j];
					// POTENTIAL ISSUE: vFar may relate to s. i.e. vFar might be the v value for sFar
					double sFar = cast(double)(check[0] > reading[0] ? check[0] : reading[0]);
					double sNear = cast(double)(check[0] < reading[0] ? check[0] : reading[0]); 
					// change to 1 maybe?
					double vFar = cast(double)(check[0] > reading[0] ? check[1] : reading[1]);
					double vNear = cast(double)(check[0] < reading[0] ? check[1] : reading[1]);
					E += kP(sFar, sNear, vFar, vNear);
					n++;
				}
			}
		}
		double k = E / cast(double)n;
		// writeln("k:\t", k);
		// solve for e
		E = 0.0;
		n =  0;
		foreach(reading; known)
		{
			double s = cast(double)reading[0];
			double v = cast(double)reading[1]; 
			E += eP(k, v, s);
			n++;
		}
		double e = E / cast(double)n;
		// writeln("e:\t", e);
		return [k, e];
	}

	void main()
	{
		ubyte calibrations, measurements;
		readf!"%u %u\n"(calibrations, measurements);
		ushort[][] known;
		foreach(x; calibrations.iota)
		{
			ushort s, v;
			readf!"%u %u\n"(s, v);
			known ~= [s, v];
		}
		double[] c = calibrate(known);
		double k = c[0];
		double e = c[1];
		ushort[] varr = readln.stripRight.split(" ").map!(a => to!ushort(a)).array;
		writefln!"k = %.10f"(k);
		writefln!"e = %.10f"(e);
		foreach (v; varr)
		{
			writefln!"%.10f"((k/sqrt(cast(double)v)) - e);
		}
	}
}

//github.com/reecejones/d-astar
version(prob20)
{
	import std.stdio;
	import std.range;
	import std.string;
	import std.typecons;
	import std.container.array;
	import std.math;

	
	//display stuff
	immutable char cp = '*';
	immutable char cc = 'o';
	immutable char co = 'x';
	uint uh = 0;
	bool showOpen = false;

	enum SolveFlags
	{
		NONE = 0,
		HORIZONTAL = (1 << 0),
		DIAGONAL = (1 << 1),
		TIE_BREAKER = (1 << 2),
	}

	class Field
	{
	public:
		//construct a field of a given width and height, with what the whitespace will be made of and what character can be moved to
		this(int width, int height, char whitespace, char movable)
		{
			this.width = width;
			this.height = height;
			foreach (i; 0..height)
			{
				char[] push;
				foreach (x; 0..width)
				{
					push ~= whitespace;
				}
				this.field ~= push;
			}
			this.mov = movable;
		}
		//display the field
		void display()
		{
			foreach (s; this.field)
			{
				writeln(s);
			}
		}
		//replace a node with a certain character
		void replace(Node n, char x)
		{
			this.field[n.y][n.x] = x;
		}
		//add a line to the field
		void pushln(string ln)
		{
			char[] build;
			foreach (c; ln)
				build ~= c;
			this.field ~= build;
		}
		//reset the field to being empty
		void reset()
		{
			this.field = [][];
		}
		//check if we can move to a certain coordinate
		bool movable(Node n)
		{
			if (n.x >= 0 && n.x < width && n.y >= 0 && n.y < height)
				return this.field[n.y][n.x] == ' '
						|| this.field[n.y][n.x] == 'X'
						|| this.field[n.y][n.x] == '@';
			return false;
		}
	private:
		//width and height of the field
		int width, height;
		//what character we can move to
		char mov;
		//array containing field
		char[][] field;
	}

	double heuristic(Node current, Node start, Node end, bool breakTies)
	{
		//we'll just use euclidean
		
		//double result = abs(sqrt(cast(float)pow(current.x - end.x, 2) + cast(float)pow(current.y - end.y, 2)));
		//double result = abs(cast(float)(current.x - end.x)) + abs(cast(float)(current.y - end.y));
		double result;
		switch (uh)
		{
			default:
			//dijkstra
				result = 1;
			break;
			case 1:
				result = abs(cast(float)(current.x - end.x)) + abs(cast(float)(current.y - end.y));
			break;
			case 2:
				result = abs(sqrt(cast(float)pow(current.x - end.x, 2) + cast(float)pow(current.y - end.y, 2)));
			break;
		}
		//if we are breaking ties we want to actually do it
		if (breakTies == true)
		{
			//tie-breaker
			/*http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html#breaking-ties*/
			int dx1 = current.x - end.x;
			int dy1 = current.y - end.y;
			int dx2 = start.x - end.x;
			int dy2 = start.y - end.y;
			double cross = abs(dx1*dy2 - dx2*dy1);
			return result + (cross*0.01);
		}
		else return result;
	}

	class Node
	{
	public:
		//constructor for constructing raw nodes
		this(int x, int y, double g, double h, double f, Node parent = null)
		{
			this._x = x;
			this._y = y;
			this._g = g;
			this._h = h;
			this._f = f;
			this._parent = parent;
		}
		//create a node using heuristics
		this(int x, int y, Node parent, Node end, Node start, bool breakTies)
		{
			this._x = x;
			this._y = y;
			this._parent = parent;
			this._g = parent.g + 1;
			this._h = heuristic(this, end, start, breakTies);
			this._f = this._g + this._h;
		}
		//get the values of the node
		double g() { return this._g; }
		double h() { return this._h; }
		double f() { return this._f; }
		int x() { return this._x; }
		int y() { return this._y; }
		Node parent() { return this._parent; }
		//for comparing nodes
		override int opCmp(Object other)
		{
			if (other is null || this is null)
				return 0;
			if (_f == (cast(Node)other).f)
				return 0;
			return _f < (cast(Node)other).f ? 1 : -1;
		}
		//for printing out nodes
		override string toString()
		{
			return format("[%d, %d, %f, %f, %f]", _x, _y, _g, _h, _f);
		}
		//check to see if a node has the same f-value
		override bool opEquals(Object other)
		{
			if (this is null || other is null)
				return false;
			if (this is other)
				return true;
			return _f == (cast(Node)other).f;
		}
	private:
		//x and y coordinates
		int _x, _y;
		//heuristic values
		double _g, _h, _f;
		//parent node for tracing back the final path
		Node _parent;
	}

	class NodeStack
	{
	public:
		this()
		{
			
		}
		/*
			the downside of this stack method is there is a O(length) worst case complexity for insertion...ouch
			but there is a really quick time to get the front node
		*/
		void insert(Node n)
		{
			if (this.stack.length == 0)
				this.stack ~= n;
			else
			{
				uint index = 0;
				Node lookup = this.stack[index];
				while (n < lookup)
				{
					index++;
					if (index == this.stack.length)
						break;
					lookup = this.stack[index];
				}
				if (index == this.stack.length)
					this.stack ~= n;
				else
					this.stack = this.stack[0..index] ~ n ~ this.stack[index..$];
			}
		}
		void insert(Node[] inserts)
		{
			foreach (n; inserts)
				this.insert(n);
		}
		Node pop(uint index)
		{
			Node ret = this.stack[index];
			this.stack = this.stack[0..index] ~ this.stack[index + 1..$];
			return ret;
		}
		Node pop()
		{
			return this.pop(0);
		}
		Node[] take(uint num, uint index)
		{
			Node[] ret;
			foreach(n; this.stack[index..index + num])
				ret ~= n;
			return ret;
		}
		ulong length()
		{
			return this.stack.length;
		}
		override string toString()
		{
			string ret;
			foreach (n; this.stack)
				ret ~= n.toString ~ '\n';
			return ret;
		}

			/*
			empty (first iteration only)
			front
			<body>
			popFront
			empty
		*/
		@property bool empty()
		{
			if (this.frontCheck == false)
			{
				this.index = 0;
				this.hasNode = false;
			}
			if (this.hasNode == true)
				return false;
			this.n = this.stack[this.index++];
			if (this.index == this.length)
			{
				this.index = 0;
				return true;
			}
			this.hasNode = true;
			return false;
		}
		@property Node front()
		{
			this.frontCheck = false;
			return n;
		}
		void popFront()
		{
			this.frontCheck = true;
			this.hasNode = false;
		}

	private:
		Node[] stack;

		Node n;
		uint index;
		bool hasNode, frontCheck;
	}

	//if i'm bored in the future, I will update this to use trees as the underlying structure
	//but for now i'm not motivated enough to figure out how to make a multidimensional tree structure
	//when i can barely make a tree by myself
	class NodeSet
	{
	public:
		this()
		{
			//blah blah blah
			this.cnt = 0;
			this.errcnt = 0;
		}
		//returns true if a new node was inserted or replaced another node
		//returns false if a node already exists and the inserting node's f-value is greater than or equal
		//to the node already in the list
		bool insert(Node n)
		{
			if (this.set.length == 0)
			{
				//this node and no parent
				this.set ~= n;
			this.cnt++;
				return true;
			}
			//iterate through the private array of nodes
			//if we find a node with matching coordinates, but a lower f-value we will replace it
			foreach (c; this.set)
			{
				if (n.x == c.x && n.y == c.y && n.f < c.f)
				{
					c = n;
					this.cnt++;
					return true;
				}
				else if (n.x == c.x && n.y == c.y)
				{
					this.errcnt++;
					return false;
				}
			}
			this.cnt++;
			this.set ~= n;
			return true;
		}
		ulong length()
		{
			return this.set.length;
		}
		//check to see if a node exists in the set
		bool nodeExists(Node n)
		{
			foreach (c; this.set)
				if (n.x == c.x && n.y == c.y)
					return true;
			return false;
		}
		//for debugging purposes
		uint insertCount()
		{
			return this.cnt;
		}
		uint errorCount()
		{
			return this.errcnt;
		}
		/*
			empty (first iteration only)
			front
			<body>
			popFront
			empty
		*/
		//for iterating through the set using input ranges
		@property bool empty()
		{
			if (this.frontCheck == false)
			{
				this.index = 0;
				this.hasNode = false;
			}
			if (this.hasNode == true)
				return false;
			this.n = this.set[this.index++];
			if (this.index == this.length)
			{
				this.index = 0;
				return true;
			}
			this.hasNode = true;
			return false;
		}
		@property Node front()
		{
			this.frontCheck = false;
			return n;
		}
		void popFront()
		{
			this.frontCheck = true;
			this.hasNode = false;
		}
	private:
		//debugging variables
		uint cnt;
		uint errcnt;

		//input range stuff
		Node n;
		uint index;
		bool hasNode, frontCheck;

		//array of nodes that makes up the set
		Node[] set;
	}

	//check to see if a node exists in a given array
	bool nodeExists(Array!Node nodes, Node n)
	{
		foreach (tmp; nodes)
			if (n.x == tmp.x && n.y == tmp.y)
				return true;
		return false;
	}

	//get the best node in a nodestack
	Node getBestNode(ref NodeStack stack, ref NodeSet closed)
	{
		bool valid = false;
		Node bestNode;
		do
		{
			//remove the best node and assign it to bestNode
			bestNode = stack.pop();
			//check to see if it exists in the closed set
			if (closed.nodeExists(bestNode) == false)
				valid = true;
		} while (valid == false);
		return bestNode;
	}

	//get successors to a given node position
	Array!Node getSuccessors(Node current, Node start, Node end, uint flags)
	{
		Array!Node successors;
		//lambda for easily adding nodes to an array
		static auto push = function(ref Array!Node a, Node n) => a.insertBack(n);
		//whether or not to break ties
		bool breakTies = !(flags & SolveFlags.TIE_BREAKER) == 0;
		//if we can move up, left, right, down
		if (flags & SolveFlags.HORIZONTAL)
		{
			push(successors, new Node(current.x + 1, current.y, current, end, start, breakTies));
			push(successors, new Node(current.x - 1, current.y, current, end, start, breakTies));
			push(successors, new Node(current.x, current.y + 1, current, end, start, breakTies));
			push(successors, new Node(current.x, current.y - 1, current, end, start, breakTies));
		}
		//if the diagonal flag is set
		if (flags & SolveFlags.DIAGONAL)
		{
			push(successors, new Node(current.x + 1, current.y + 1, current, end, start, breakTies));
			push(successors, new Node(current.x - 1, current.y - 1, current, end, start, breakTies));
			push(successors, new Node(current.x - 1, current.y + 1, current, end, start, breakTies));
			push(successors, new Node(current.x + 1, current.y - 1, current, end, start, breakTies));
		}
		return successors;
	}

	//solve a maze using the a* algorithm
	Array!Node Astar(Node start, Node end, int width, int height, ref Field field, uint expected,
					uint flags = SolveFlags.HORIZONTAL | SolveFlags.DIAGONAL | SolveFlags.TIE_BREAKER)
	{
		//open set containing nodes that are being considered
		NodeStack open = new NodeStack();
		//closed set containing nodes we've traveled to
		NodeSet closed = new NodeSet();
		//we need a starting point, so why don't we start at the start
		open.insert(start);
		//if there are no nodes left being considered there is no path
		while (open.length != 0)
		{
			//q is the best node in the open set
			Node q = getBestNode(open, closed);
			//get potential nodes
			Array!Node successors = getSuccessors(q, end, start, flags);
			//iterate the successors and insert them into the open set
			foreach(n; successors)
			{
				//if a successor is the end we want to travel to it
				if (n.x == end.x && n.y == end.y)
				{
					//trace back the best path
					Array!Node path;
					Node tmp = n;
					path.insertBack(tmp);
					do
					{
						tmp = tmp.parent;
						path.insertBack(tmp);
					} while (tmp.parent !is null);
					if (showOpen == true)
						foreach(z; open)
							field.replace(z, cc);
					return path;
				}
				else if (field.movable(n) == true)
				{
					open.insert(n);
				}
			}
			closed.insert(q);
		}
		//return an empty array
		writeln("found no solution.");
		return Array!Node();
	}

	void main()
	{
		ubyte width, height;
		readf!"%u %u\n"(width, height);
		string[] field;
		foreach(x; height.iota)
			field ~= readln.stripRight;
		Node start, end;
		foreach(i; height.iota)
		{
			foreach(j; width.iota)
			{
				if (field[i][j] == '@')
				{
					start = new Node(j, i, 0.0, 0.0, 0.0);
				}
				if (field[i][j] == 'X')
				{
					end = new Node(j, i, 0.0, 0.0, 0.0);
				}
			}
		}

		Field f = new Field(width, height, ' ', ' ');
		f.reset();
		foreach(ln; field)
			f.pushln(ln);
		auto fastestPath = Astar(start, end, width, height, f, 100_000,
					SolveFlags.HORIZONTAL | SolveFlags.DIAGONAL | SolveFlags.TIE_BREAKER);
		foreach(n; fastestPath[1..$-1])
		{
			// n.writeln;
			f.replace(n, '*');
		}
		f.display();
	}
}

version (prob21)
{
	import std.stdio;
	import std.string;
	import std.range;
	import std.algorithm;

	string getLongestMatch(uint baseIndex, string baseString, string matchString)
	{
		string longest;
		for (uint i = baseIndex; i <= baseString.length; i++)
		{
			// found a match in the matchString
			if (matchString.indexOf(baseString[baseIndex..i]) != -1)
			{
				if (baseString[baseIndex..i].length > 1)
					longest = baseString[baseIndex..i];
			}
		}
		return longest;
	}

	void main()
	{
		uint defs;
		readf!"%u\n"(defs);
		string[] answers;
		foreach(x; defs.iota)
		{
			auto s = readln.stripRight.split(" - ");
			string def = s[0];
			string desc = s[1];
			string attempt;
			uint index;
			while (attempt.length <= def.length)
			{
				string add = getLongestMatch(index, def, desc);
				// no match found...invalid
				if (add.length == 0)
				{
					answers ~= "Imperfect!";
					break;
				}
				else
				{
					attempt ~= add;
					index += add.length;
					if (attempt == def)
					{
						answers ~= "Perfect";
						break;
					}
				}
			}
		}
		answers.each!(a => writeln(a));
	}
}
}
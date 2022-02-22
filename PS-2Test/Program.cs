using System;
using System.IO;
namespace ConsoleApp5
{  
    class Program
    {
        public static void PS2_port(string [] buttonCode)
        {
            string[] setCodesHost = new string[buttonCode.Length];
            string[] setCodesDevice = new string[buttonCode.Length];
            string[] breakCodesHost = new string[buttonCode.Length];
            string[] breakCodesDevice = new string[buttonCode.Length];
            for (int j = 0; j < buttonCode.Length;j++)
            {
                const string f0Code = "11110000";
                char[] subStrDev = new char[11];
                char[] subStrHost = new char[12];
                char[] subStrBreakDev = new char[19];
                char[] subStrBreakHost = new char[20];
                char[] subStrForAll = buttonCode[j].ToCharArray();

                int count = 0;
                subStrDev[0] = '0';
                for (int i = 8; i >= 1; i--)
                {
                    subStrDev[i] = subStrForAll[8 - i];
                    if (subStrForAll[8 - i] == '0')
                    {
                        count += 1;
                    }
                }
                subStrDev[9] = count % 2 == 0 ? '1' : '0';
                subStrDev[10] = '1';
                char[] f0CodeArr = f0Code.ToCharArray();
                Array.Copy(subStrDev, subStrHost, subStrDev.Length);
                subStrHost[11] = '0';
                string setCodeDevice = new string(subStrDev);
                string setCodeHost = new string(subStrHost);
                Array.Copy(f0CodeArr, subStrBreakDev, f0CodeArr.Length);
                Array.Copy(f0CodeArr, subStrBreakHost, f0CodeArr.Length);
                for (int i = 8; i < 19; i++)
                {
                    subStrBreakDev[i] = subStrDev[i - 8];
                    subStrBreakHost[i] = subStrHost[i - 8];
                }
                subStrBreakHost[19] = '0';
                setCodesDevice[j] = setCodeDevice;
                setCodesHost[j] = setCodeHost;
                string breakCodeDevice = new string(subStrBreakDev);
                string breakCodeHost = new string(subStrBreakHost);
                breakCodesDevice[j] = breakCodeDevice;
                breakCodesHost[j] = breakCodeHost;
            }

            Console.WriteLine("setCodes на С#");
            for (int i = 0; i < buttonCode.Length; i++)
            {
                Console.WriteLine(setCodesDevice[i]);
                Console.WriteLine(setCodesHost[i]);
            }
            string setCodesFile = System.IO.File.ReadAllText(@"C:\PS-2\setCodes.txt");
            Console.WriteLine("setCodes на VHDL из файла \n{0}", setCodesFile);
            Console.WriteLine("breakCodes на С#");
            for (int i = 0; i < buttonCode.Length; i++)
            {
                Console.WriteLine(breakCodesDevice[i]);
                Console.WriteLine(breakCodesHost[i]);
            }
            string breakCodesFile = System.IO.File.ReadAllText(@"C:\PS-2\breakCodes.txt");
            Console.WriteLine("breakCodes на VHDL из файла \n{0}", breakCodesFile);

        }
        public static void randomValues ()
        {
            string[] test_codes = { "00101011", "00101110","00001110","00011010","00001110","00010110","00100101","01110111","00111101",
            "00111110","01000101","01001110","01010101","01011101"};
            Random m = new Random();
            StreamWriter sw = new StreamWriter(@"C:\KursachRuchki\keys.txt", true);
            string[] forWrite = new string[5];
            string line = "";
            for (int i = 0; i < 5; i++)
            {
                line = test_codes[new Random().Next(0, test_codes.Length)];
                if (Array.IndexOf(forWrite, line) == -1)
                {
                    forWrite[i] = line;
                    sw.WriteLine(line);
                }
                else
                {
                    i--;
                }
            }
            sw.Close();
        }
        static void Main(string[] args)
        {

            StreamReader f = new StreamReader(@"C:\PS-2\keys.txt");
            int i = 0;
            string[] forWrite = new string[5];
            while (!f.EndOfStream)
            {
                 forWrite[i] = f.ReadLine();
                 i++;
            }
            f.Close();
            PS2_port(forWrite);
        }
    }
}

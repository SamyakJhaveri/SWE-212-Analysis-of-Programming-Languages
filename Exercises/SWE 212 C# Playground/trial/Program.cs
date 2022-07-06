// See https://aka.ms/new-console-template for more information
namespace HelloWorld
{
    class SamProgram
    {
        static void Main(string[] args)
        {
            string path_to_file = @"../pride-and-prejudice.txt";
            //string [] lines = File.ReadAllLines(path_to_file);
            List<string> lines = new List<string>();
            lines = File.ReadAllLines(path_to_file).ToList();

            foreach(String line in lines)
            {
                Console.WriteLine(line);
            }
        }
    }
}
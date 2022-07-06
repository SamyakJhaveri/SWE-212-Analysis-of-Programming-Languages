/*
def load_plugins():
    config = configparser.ConfigParser()
    config.read("config.ini")
    words_plugin = config.get("Plugins", "words")
    frequencies_plugin = config.get("Plugins", "frequencies")
    global tfwords, tffreqs
    tfwords = importlib.machinery.SourcelessFileLoader('tfwords', words_plugin).load_module()
    tffreqs = importlib.machinery.SourcelessFileLoader('tffreqs', frequencies_plugin).load_module()

load_plugins()
word_freqs = tffreqs.top25(tfwords.extract_words(sys.argv[1]))

for (w, c) in word_freqs:
    print(w, '-', c)

*/

using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;
using words1lib;
using frequencies1lib;

public class frameworkClass
{
    public void load_plugins(string ptf)
    {
        words1Class words1_obj = new words1Class();
        frequencies1Class frequencies1_obj = new frequencies1Class();

        frequencies1_obj.top25(words1_obj.extract_words(ptf));

    }
    public static void Main(string[] args)
    {
        frameworkClass obj = new frameworkClass();

        string[] arguments_recieved = Environment.GetCommandLineArgs();
        string ptf = arguments_recieved[1];
        obj.load_plugins(ptf);
    }
}

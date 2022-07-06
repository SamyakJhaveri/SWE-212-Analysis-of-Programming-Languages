using System;
using System.Linq;
using System.IO;
using System.Reflection;
using System.Xml;
using System.Collections.Generic;

public class TwentyClass
{
    string frequencies_package;
    string words_package;

    public void load_plugins(string config_file_path)
    {
        XmlDocument config_file = new XmlDocument();
        config_file.Load(config_file_path);
        var words = (XmlElement)config_file.GetElementsByTagName("words")[0];
        var frequencies = (XmlElement)config_file.GetElementsByTagName("frequencies")[0];
        frequencies_package = frequencies.GetAttribute("usepkg");
        words_package = words.GetAttribute("usepkg");  
    }

    public static void Main(string[] args)
    {
        words1Class words1_obj = new words1Class();
        frequencies1Class frequencies1_obj = new frequencies1Class();
        load_plugins("packages/config.xml");

        string[] arguments_recieved = Environment.GetCommandLineArgs();
        string ptf = arguments_recieved[1];
        
        frequencies1_obj.top25(words1_obj.extract_words(ptf));

    }

}
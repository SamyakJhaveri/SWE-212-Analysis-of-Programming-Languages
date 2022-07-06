using System;
using System.Linq;
using System.IO;
using System.Reflection;
using System.Xml;
using System.Collections.Generic;

public static class TwentyClass
{
    public static string frequencies_package;
    public static string words_package;

    public static void load_plugins(string config_file_path)
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
        Object words_obj, frequencies_obj;
        MethodInfo words_method, frequencies_method;

        load_plugins("packages/config.xml");

        Assembly words_assembly = Assembly.LoadFrom(words_package);
        Type words_class = words_assembly.GetType("wordslib1.wordsClass");
        //Type words_class = words_assembly.GetType("wordsClass");
        words_obj = Activator.CreateInstance(words_class);
        words_method = words_class.GetMethod("extract_words");
               
        Assembly frequencies_assembly = Assembly.LoadFrom(frequencies_package);
        Type frequencies_class = frequencies_assembly.GetType("frequencieslib1.frequenciesClass");
        //Type frequencies_class = frequencies_assembly.GetType("frequenciesClass");
        frequencies_obj = Activator.CreateInstance(frequencies_class);
        frequencies_method = frequencies_class.GetMethod("top25");
        
        /*string[] arguments_recieved = Environment.GetCommandLineArgs();
        string ptf = arguments_recieved[1];*/
        List<string> cwl = new List<string>();
        cwl = (List<string>)words_method.Invoke(words_obj, new string[]{args[0], "../../../stop_words.txt"});
        
        Dictionary<string, int> result = new Dictionary<string, int>();
        result = (Dictionary<string, int>)frequencies_method.Invoke(frequencies_obj, new object []{cwl});

        foreach(var item in result.Take(25))
        {
            Console.WriteLine(item.Key + " - " + item.Value);
        }
    }
}
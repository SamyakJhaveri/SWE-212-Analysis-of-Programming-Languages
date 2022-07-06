/*
Style #17
Completed on 1st May 2022

Constraints:

The problem is decomposed using some form of abstraction (procedures, functions, objects, etc.)

The abstractions have access to information about themselves, although they cannot modify that information

Possible names:

Introspective
Navel-gazing
*/
// dotnet add package Newtonsoft.Json

using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
//using Newtonsoft.Json;

abstract class TF17
{
    protected string info()
    {
        return this.GetType().Name;
    }
}
public class SeventeenClass
{
    public static void printout(string classChosen)
    {
        var class_type = Type.GetType(classChosen);
        
        var binds = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;
        FieldInfo[] fields = class_type.GetFields(binds);
        Console.WriteLine("Fields:");
        foreach(var field in fields)
        {
            Console.WriteLine(field.ToString());
        }

        MethodInfo[] methods = class_type.GetMethods(binds);
        Console.WriteLine("Methods:");
        foreach (var method in methods)
        {
            Console.WriteLine(method.ToString());
        }
        
        Console.WriteLine("Superclasses:");
        Console.WriteLine(class_type.BaseType);

        Console.WriteLine("Interfaces:");
        var interf = class_type.GetInterfaces();
        foreach (var itf in interf)
        {
            Console.WriteLine(itf.ToString());    
        }
        
    } 

    public static void Main(string[] args)
    {
        string[] arguments_recieved = Environment.GetCommandLineArgs();
        WordFrequencyController wfcobj = new WordFrequencyController(arguments_recieved[1]);
        wfcobj.run();


        Console.WriteLine("Please enter \nDataStorageManager, \nStopWordManager, \nWordFrequencyManager, or \nWordFrequencyController.");
        string classChosen = Console.ReadLine();
        printout(classChosen);
    }
}


class DataStorageManager : TF17
{
    public string _data = "";
    public DataStorageManager(string path_to_file)
    {
        _data = File.ReadAllText(path_to_file);
        _data = _data.ToLower();
        Regex rgx = new Regex("[^a-z]");
        _data = rgx.Replace(_data, " ");
    }
    
    public string[] words()
    {
        return (_data.Split(" "));
    }
}

class StopWordManager : TF17
{
    public string[] _stop_words;

    public StopWordManager()
    {
        string sw_path = "../../../stop_words.txt";
        string sw = File.ReadAllText(sw_path);
        string[] stopwords_list = sw.Split(",");

        char[] alpha = "abcdefghijklmnopqrstuvwxyz".ToCharArray();
        List<string> alpha_string = new List<string>();
        foreach(char c in alpha)
        {
            alpha_string.Add(c.ToString());
        }        
        _stop_words = stopwords_list.Concat(alpha_string.ToArray()).ToArray();
    }

    public bool is_stop_word(string word)
    {
        if (Array.Exists(_stop_words, element => element == word))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

class WordFrequencyManager : TF17
{
    public Dictionary<string, int> _word_freqs = new Dictionary<string, int>();

    public void increment_count(string word)
    {
        //int count = 0;
        if (_word_freqs.ContainsKey(word))
        {
            //_word_freqs.TryGetValue(word, out count);
            _word_freqs[word]++; //= count + 1;
        }
        else
        {
            _word_freqs.Add(word, 1);// = 1;
        }
    }
    
    public  List<KeyValuePair<string, int>> sorted()
    {
        var list = _word_freqs.ToList();
        list.Sort((x, y) => y.Value.CompareTo(x.Value));
        
        return list;
    }
}
class WordFrequencyController : TF17
{
    public DataStorageManager _storage_manager {get; set;} 
    public StopWordManager _stop_word_manager = new StopWordManager();
    public WordFrequencyManager _word_freq_manager = new WordFrequencyManager();
    
    public WordFrequencyController(string path_to_file)
    {
        _storage_manager = new DataStorageManager(path_to_file);
    }
    /*public static Dictionary<string, int> ToDictionary(object obj)
    {       
        var json = JsonConvert.SerializeObject(obj);
        var dictionary = JsonConvert.DeserializeObject<Dictionary<string, int>>(json);   
        return dictionary;
    }*/

    public void run()
    {

        Type sm_type = _storage_manager.GetType();
        Type swm_type = _stop_word_manager.GetType();
        Type wfm_type = _word_freq_manager.GetType();
        
        System.Reflection.MethodInfo sm_info_words = sm_type.GetMethod("words");
        System.Reflection.MethodInfo swm_info_is = swm_type.GetMethod("is_stop_word");
        System.Reflection.MethodInfo wfm_info_ic = wfm_type.GetMethod("increment_count");
        System.Reflection.MethodInfo wfm_info_s = wfm_type.GetMethod("sorted");

        string[] word_list = (string[]) (sm_info_words.Invoke(_storage_manager, new object[]{}));
        foreach(string w in word_list)
        {
            bool check_sw = (bool)swm_info_is.Invoke(_stop_word_manager, new object[]{w});
            if (check_sw == false)
            {
                wfm_info_ic.Invoke(_word_freq_manager, new object[]{w});
            }
            else
            {
                continue;
            }
        }

        foreach (var item in ((List<KeyValuePair<string, int>>)wfm_info_s.Invoke(_word_freq_manager, new object[]{})).GetRange(1, 25))
        {
            Console.WriteLine(item.Key + "  -  " + item.Value);
        }
        /*word_freqs = ToDictionary(wfm_info_s.Invoke(_word_freq_manager, new object[]{}));
        foreach(var item in word_freqs.Take(25))
        {
            Console.WriteLine(item.Key + " - " + item.Value);
        }*/

    }
}


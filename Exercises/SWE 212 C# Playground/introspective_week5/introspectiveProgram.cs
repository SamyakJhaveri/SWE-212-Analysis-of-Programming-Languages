using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;
using System.Reflection;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

using Newtonsoft.Json;

string[] arguments_recieved = Environment.GetCommandLineArgs();

WordFrequencyController wfcobj = new WordFrequencyController(arguments_recieved[1]);
/*DataStorageManager dsobj = new DataStorageManager(arguments_recieved[1]);
StopWordManager swobj = new StopWordManager();
WordFrequencyManager wfobj = new WordFrequencyManager();*/
Type ds_type = Type.GetType("DataStorageManager");   //typeof(DataStorageManager);
Type sw_type = Type.GetType("StopWordManager");//typeof(StopWordManager);
Type wf_type = Type.GetType("WordFrequencyManager");//typeof(WordFrequencyManager);
Type wfc_type = Type.GetType("WordFrequencyController");//typeof(WordFrequencyController);

FieldInfo[] ds_fields = ds_type.GetFields();
FieldInfo[] sw_fields = sw_type.GetFields();
FieldInfo[] wf_fields = wf_type.GetFields();
FieldInfo[] wfc_fields = wfc_type.GetFields();

MethodInfo[] ds_methods = ds_type.GetMethods();
MethodInfo[] sw_methods = sw_type.GetMethods();
MethodInfo[] wf_methods = wf_type.GetMethods();
MethodInfo[] wfc_methods = wfc_type.GetMethods();

Assembly assembly = Assembly.GetExecutingAssembly();
Type[] types = assembly.GetTypes();
int i = 0;
string nameType;

void printout(string className, FieldInfo[] fields, MethodInfo[] methods, Type classType)
{
    foreach(var field in fields)
    {
        i++;
        nameType = field.FieldType.ToString(); // get the name of the field type of structure Worker
        Console.WriteLine("Field[{0}] = {1}, type = {2}", i, field.Name, nameType);
    }
    i = 0;
    foreach (MethodInfo mi in methods)
    {
        i++;
        Console.WriteLine("Method[{0}] = {1}", i, mi.Name);
    }
    IEnumerable<Type> subclasses = types.Where(t => t.BaseType == classType);
    if (subclasses.Any())
    {
        foreach(Type type in subclasses)
        {
            Console.WriteLine("Child/Base Class: " + type.Name);
        }
    }
    else
    {
        Console.WriteLine("This Class does not have any Child/Base Classes.");
    }
}

Console.WriteLine("Please enter \n1 for DataStorageManager class, \n2 for StopWordManager class, \n3 for WordFrequencyManager class, and \n4 for WordFrequencyController class.");
int classChosen = Convert.ToInt32(Console.ReadLine());
if (classChosen == 1)
{
    printout("DataStorageManager", ds_fields, ds_methods, ds_type);
}
else if (classChosen == 2)
{
    printout("StopWordManager", sw_fields, sw_methods, sw_type);
}
else if (classChosen == 3)
{
    printout("WordFrequencyManager", wf_fields, wf_methods, wf_type);
    
}
else if (classChosen == 4)
{
    printout("WordFrequencyController", wfc_fields, wfc_methods, wfc_type);
}

/*abstract class TFExercise
{
    public string getInfo()
    {
        return this.GetType().GetName();
    }
}*/
wfcobj.run();
public class ChildforFun1 : WordFrequencyManager
{
    public int age = 27;
    public ChildforFun1()
    {
        Console.Write("Age is:" + age);
    }
}
public class ChildforFun2 : StopWordManager
{
    public int age = 22;
    public ChildforFun2()
    {
        Console.Write("Age is:" + age);
    }
}
public class DataStorageManager 
{
    public string _data = "";
    public DataStorageManager(string path_to_file)
    {
        //Console.WriteLine("Inside DataStorageManager Constructor 11");
        _data = File.ReadAllText(path_to_file);
        _data = _data.ToLower();
        Regex rgx = new Regex("[^a-z]");
        _data = rgx.Replace(_data, " ");
    }
    
    public string[] words()
    {
        //Console.WriteLine("Inside DataStorageManager words() 22");
        return (_data.Split(" "));
    }

    /*public string getInfo()
    {
        // somethign from the code
        return base.getInfo() + ": My major data structure is a " + this._data.GetType().Name;

    }*/
}

public class StopWordManager
{
    public string[] _stop_words;

    public StopWordManager()
    {
        //Console.WriteLine("Inside StopWordsManager Constructor 33");
        string sw_path = "../../stop_words.txt";
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
        //Console.WriteLine("Inside DataStorageManager is_stop_word() 44");
        if (Array.Exists(_stop_words, element => element == word))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    /*public string getInfo()
    {
        return base.getInfo() + ": My major data structure is a " + this._stop_words.GetType().Name;
    }*/
}

public class WordFrequencyManager
{
    public Dictionary<string, int> _word_freqs = new Dictionary<string, int>();

    public void increment_count(string word)
    {
        //Console.WriteLine("Inside WordFrequencyManager increment_count() 55");
        int count = 0;
        if (_word_freqs.ContainsKey(word))
        {
            _word_freqs.TryGetValue(word, out count);
            _word_freqs[word] = count + 1;
        }
        else
        {
            _word_freqs[word] = 1;
        }
    }
    
    public Dictionary<string, int> sorted()
    {
        //Console.WriteLine("Inside WordFrequencyManager sorted() 66");
        var reversed_word_freqs = from entry in _word_freqs orderby entry.Value descending select entry;
        Dictionary<string, int> final_word_freqs = new Dictionary<string, int>();

        final_word_freqs = reversed_word_freqs.ToDictionary(pair => pair.Key, pair => pair.Value);
        final_word_freqs.Remove(final_word_freqs.Keys.First());

        return final_word_freqs;
    }

    /*public string getInfo()
    {
        return base.getInfo() + ": My major data structure is a " + this._word_freqs.GetType().Name;
    }*/
}
public class WordFrequencyController
{
    public DataStorageManager _storage_manager {get; set;} 
    public StopWordManager _stop_word_manager = new StopWordManager();
    public WordFrequencyManager _word_freq_manager = new WordFrequencyManager();
    
    public WordFrequencyController(string path_to_file)
    {
        //Console.WriteLine("Inside WordFrequencyController Constructor 77");
        _storage_manager = new DataStorageManager(path_to_file);

    }
    public static Dictionary<string, int> ToDictionary(object obj)
    {       
        //Console.WriteLine("Inside WordFrequenyController ToDictionary 88");
        var json = JsonConvert.SerializeObject(obj);
        var dictionary = JsonConvert.DeserializeObject<Dictionary<string, int>>(json);   
        return dictionary;
    }

    public void run()
    {
        //Console.WriteLine("Inside WordFrequencyController run() 99");

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
        Dictionary<string, int> word_freqs = new Dictionary<string, int>();
        word_freqs = ToDictionary(wfm_info_s.Invoke(_word_freq_manager, new object[]{}));
        foreach(var item in word_freqs.Take(25))
        {
            Console.WriteLine(item.Key + " - " + item.Value);
        }

    }
}


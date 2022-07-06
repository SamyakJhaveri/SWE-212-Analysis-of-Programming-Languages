using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;

string[] arguments_recieved = Environment.GetCommandLineArgs();

WordFrequencyController wfcobj = new WordFrequencyController(arguments_recieved[1]);
wfcobj.run();

abstract class TFExercise
{
    public string getInfo()
    {
        return this.getType().getName();
    }
}

public class DataStorageManager
{
    private string _data = "";
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

    public string getInfo()
    {
        // somethign from the code
        return base.getInfo() + ": My major data structure is a " + this._data.GetType().Name;

    }
}

public class StopWordManager
{
    private string[] _stop_words;

    public StopWordManager()
    {
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
        if (Array.Exists(_stop_words, element => element == word))
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public string getInfo()
    {
        return base.getInfo() + ": My major data structure is a " + this._stop_words.GetType().Name;
    }
}

public class WordFrequencyManager
{
    private Dictionary<string, int> _word_freqs = new Dictionary<string, int>();

    public void increment_count(string word)
    {
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
        var reversed_word_freqs = from entry in _word_freqs orderby entry.Value descending select entry;
        Dictionary<string, int> final_word_freqs = new Dictionary<string, int>();

        final_word_freqs = reversed_word_freqs.ToDictionary(pair => pair.Key, pair => pair.Value);
        final_word_freqs.Remove(final_word_freqs.Keys.First());

        return final_word_freqs;
    }

    public string getInfo()
    {
        return base.getInfo() + ": My major data structure is a " + this._word_freqs.GetType().Name;
    }
}
public class WordFrequencyController
{
    private DataStorageManager _storage_manager {get; set;} 
    private StopWordManager _stop_word_manager = new StopWordManager();
    private WordFrequencyManager _word_freq_manager = new WordFrequencyManager();
    
    public WordFrequencyController(string path_to_file)
    {
        _storage_manager = new DataStorageManager(path_to_file);

    }

    public void run()
    {  
        foreach(string w in _storage_manager.words())
        {
            if (_stop_word_manager.is_stop_word(w) == false)
            {
                _word_freq_manager.increment_count(w);
            }
            else
            {
                continue;
            }
        }

        Dictionary<string, int> word_freqs = new Dictionary<string, int>();
        word_freqs = _word_freq_manager.sorted();
        foreach(var item in word_freqs.Take(25))
        {
            Console.WriteLine(item.Key + " - " + item.Value);
        }
        
    }
}


using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;


public class words1
{
    public List<string> extract_words(string path_to_file)
    {
        string data = "";
        data = File.ReadAllText(path_to_file);
        data = data.ToLower();
        Regex rgx = new Regex("[^a-z]");//[\\W_]+");
        data = rgx.Replace(data, " ");

        string[] word_list = (data.Split(" "));
        string sw_path = "stop_words.txt";
        string sw = File.ReadAllText(sw_path);
        string[] stopwords_list = sw.Split(",");

        char[] alpha = "abcdefghijklmnopqrstuvwxyz".ToCharArray();
        List<string> alpha_string = new List<string>();
        foreach(char c in alpha)
        {
            alpha_string.Add(c.ToString());
        }

        string[] stopwords = stopwords_list.Concat(alpha_string.ToArray()).ToArray();
        List<string> cleaned_word_list = new List<string>(); //word_list with stopwords removed
        foreach(string word in word_list)
        {
            if  (stopwords.Contains(word) == false)
            {
                cleaned_word_list.Add(word);
            }

        }
        return cleaned_word_list;
    }

    public static void Main(string[] args){
        words1Class obj = new words1Class();
        string ptf = "../../pride-and-prejudice.txt";
        List<string> result = obj.extract_words(ptf);
    }
}


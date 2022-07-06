using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Linq;

public class frequencies1
{
    public void top25(List<string> cleaned_word_list)
    {
        Dictionary<string, int> word_freqs = new Dictionary<string, int>();
            int count;
            foreach(string word in cleaned_word_list)
            {
                if (word_freqs.ContainsKey(word))
                {
                    word_freqs.TryGetValue(word, out count);
                    word_freqs[word] = count + 1;
                }
                else
                {
                    //word_freqs.TryGetValue(word, out count);
                    word_freqs[word] = 1;
                }
                count = 0;

            }
            var reversed_word_freqs = from entry in word_freqs orderby entry.Value descending select entry;//word_freqs.Reverse();
            //reversed_word_freqs
            Dictionary<string, int> final_word_freqs = new Dictionary<string, int>();
            final_word_freqs = reversed_word_freqs.ToDictionary(pair => pair.Key, pair => pair.Value);
            final_word_freqs.Remove(final_word_freqs.Keys.First());

            foreach(var item in final_word_freqs.Take(25))
            {
                Console.WriteLine(item.Key + " - " + item.Value);
            }
    }

    public static void Main(string[] args)
    {
        frequencies1Class obj = new frequencies1Class();
        List<string> cleaned_word_list = new List<string>(){"New York",
                        "London",
                        "Mumbai",
                        "Chicago"};
        obj.top25(cleaned_word_list);
    }
}

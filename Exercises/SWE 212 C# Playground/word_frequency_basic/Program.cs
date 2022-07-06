using System;

class WordFrequency
{
    public static int CountWordsFrequency(string sentence, string word)
    {
        int cnt = 0;
        int i = 0;
        while ((i = sentence.IndexOf(word, i)) != -1)
        {
            i += word.Length;
            cnt ++;
        }
        return cnt;
    }
    public static void Main()
    {
        string sentence;

        Console.Write("Enter the Sentence:");
        sentence = Console.ReadLine();
        Console.WriteLine(CountWordsFrequency(sentence, "the"));
    }
}
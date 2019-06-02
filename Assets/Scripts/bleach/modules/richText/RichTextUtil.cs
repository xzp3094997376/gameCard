
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;

class RichTextUtil
{

    private static List<string> result = new List<string>();

    public static string[] GroupString(string s)
    {
        result.Clear();
        if (string.IsNullOrEmpty(s))
            return null;
        int startIndex = 0;
        int endIndex = 0;
        string saveString;
        string pattern = "<br=[0-9]+>";
        MatchCollection matchs = Regex.Matches(s, pattern);
        int counts = matchs.Count;
        if (counts > 0)
        {
            for (int i = 0; i < counts; i++)
            {
                startIndex = i > 0 ? matchs[i - 1].Index + matchs[i - 1].Value.Length : 0;
                endIndex = i > 0 ? matchs[i].Index - matchs[i - 1].Index - matchs[i - 1].Value.Length : matchs[i].Index;
                string partFirst = s.Substring(startIndex, endIndex);
                saveString = partFirst;
                if (!string.IsNullOrEmpty(saveString))
                {
                    analysisFontSize(saveString);
                }
                saveString = matchs[i].Value;
                result.Add(saveString);
                if (i == counts - 1)
                {
                    if (matchs[i].Index + matchs[i].Value.Length < s.Length)
                    {
                        startIndex = matchs[i].Index + matchs[i].Value.Length;
                        endIndex = s.Length - startIndex;
                        saveString = s.Substring(startIndex, endIndex);
                        analysisFontSize(saveString);
                    }
                }
            }
        }
        else
        {
            analysisFontSize(s);
        }
        return result.ToArray();
    }

    public static void analysisFontSize(string value)
    {
        if (string.IsNullOrEmpty(value))
            return;
        int startIndex = 0;
        int endIndex = 0;
        string saveString;
        string pattern = "(?<=<font=.*\\d>).*?(?=</font>)";
        MatchCollection matchs = Regex.Matches(value, pattern);
        int counts = matchs.Count;
        if (counts > 0)
        {
            for (int i = 0; i < counts; i++)
            {
                startIndex = i > 0 ? matchs[i - 1].Index + matchs[i - 1].Value.Length + 7 : 0;
                endIndex = i > 0 ? matchs[i].Index - matchs[i - 1].Index - matchs[i - 1].Value.Length - 7 : matchs[i].Index;
                string partFirst = value.Substring(startIndex, endIndex);  //xxxxx<font=20>
                int indexFont = partFirst.IndexOf("<font=");
                saveString = partFirst.Substring(0, indexFont);
                if (!string.IsNullOrEmpty(saveString))
                {
                    result.Add(saveString);
                }
                string fontSize = partFirst.Substring(indexFont + 6, partFirst.Length - indexFont - 7);
                saveString = fontSize + "ξ" + matchs[i].Value;
                result.Add(saveString);
                if (i == counts - 1)
                {
                    if (matchs[i].Index + matchs[i].Value.Length + 7 < value.Length)
                    {
                        startIndex = matchs[i].Index + matchs[i].Value.Length + 7;
                        endIndex = value.Length - startIndex;
                        saveString = value.Substring(startIndex, endIndex);
                        result.Add(saveString);
                    }
                }
            }
        }
        else
        {
            result.Add(value);
        }
    }
}


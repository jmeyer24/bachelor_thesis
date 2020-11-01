using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DataReader : MonoBehaviour
{
    public TextAsset nodes;
    public TextAsset arcs;

    public List<List<float>> nodeInfo = new List<List<float>>();
    public List<List<float>> arcInfo = new List<List<float>>();

    void Start()
    {
        FillInfo(nodes, nodeInfo);
        FillInfo(arcs, arcInfo);
    }

    void FillInfo(TextAsset asset, List<List<float>> list)
    {
        string[] lines = asset.text.Split('\n');

        for (int i = 0; i < lines.Length - 1; i++)
        {
            string[] array = lines[i + 1].Split('\t');

            if(array.Length == 1)
            {
                continue;
            }

            list.Add(new List<float>());

            for (int j = 0; j < 5; j++)
            {
                list[i].Add(float.Parse(array[j], System.Globalization.CultureInfo.InvariantCulture.NumberFormat));
            }
        }
    }
}

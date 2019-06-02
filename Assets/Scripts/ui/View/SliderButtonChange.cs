using UnityEngine;
using System.Collections;

public class SliderButtonChange : MonoBehaviour
{
    public UISlider slider;
    public GameObject ButtonOne;
    public GameObject ButtonTwo;
    private float valueTo = 0;
    private float old = 0;
    bool isMove = false;
    private float time = 0;
    void Start()
    {
        slider.value = 0;
        if (slider == null) slider = gameObject.GetComponent<UISlider>();
        if (slider)
            slider.onChange.Add(new EventDelegate(onChange));
        Invoke("init", 0.1f);
    }
    void init()
    {
        value = 0;
    }
    public int value
    {
        set
        {
            if (slider == null) return;
            old = slider.value;
            valueTo = value;
            isMove = true;
            time = 0;
        }
    }
    private void onChange()
    {
        if (slider.value <= 0f)
        {
            ButtonOne.SetActive(false);
            ButtonTwo.SetActive(true);

        }
        else if (slider.value >= 1f)
        {
            ButtonOne.SetActive(true);
            ButtonTwo.SetActive(false);

        }
        else
        {
            ButtonOne.SetActive(true);
            ButtonTwo.SetActive(true);
        }
    }
    void Update()
    {
        if (isMove && slider && time < 1)
        {
            time += Time.deltaTime;
            float val = Mathf.Lerp(old, valueTo, time * 3);

            slider.value = val;
            if (slider.value == valueTo)
            {
                isMove = false;
            }
        }

    }
}

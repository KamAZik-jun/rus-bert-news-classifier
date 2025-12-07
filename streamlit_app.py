import streamlit as st
from transformers import BertTokenizer, BertForSequenceClassification
import torch

st.title("📰 Russian News Classifier (3-class BERT)")

# Загружаем модель из HF
model_name = "/rus_bert_3class_model"

tokenizer = BertTokenizer.from_pretrained("rus_bert_3class_model")
model = BertForSequenceClassification.from_pretrained("rus_bert_3class_model")
model.eval()

label_map = {
    0: "Культура",
    1: "Политика",
    2: "Наука"
}

text = st.text_area("Введите новость для классификации:", height=200)

if st.button("Классифицировать"):
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True)
    with torch.no_grad():
        outputs = model(**inputs)
        pred = torch.argmax(outputs.logits, dim=1).item()

    st.subheader("Результат:")
    st.write(f"**Класс:** {label_map[pred]}")

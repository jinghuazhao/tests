# 10 Python One-Liners for Scikit-learn

Web: <https://www.kdnuggets.com/10-python-one-liners-for-scikit-learn>

## One-liners

```python
# 1. Import Scikit-learn Modules in One Line
from sklearn import datasets, model_selection, preprocessing, metrics, svm, decomposition, pipeline
# 2. Load the Iris Dataset
X, y = datasets.load_iris(return_X_y=True)
# 3. Split Data into Train and Test Sets
X_train, X_test, y_train, y_test = model_selection.train_test_split(X, y, test_size=0.2, random_state=42)
# 4. Standardize Features
X_train_scaled = preprocessing.StandardScaler().fit_transform(X_train)
# 5. Reduce Dimensionality with PCA
X_reduced = decomposition.PCA(n_components=2).fit_transform(X)
# 6. Train an SVM Classifier
svm_model = svm.SVC(kernel='linear', C=1.0, random_state=42).fit(X_train, y_train)
# 7. Generate a Confusion Matrix
conf_matrix = metrics.confusion_matrix(y_test, svm_model.predict(X_test))
# 8. Perform Cross-Validation
cv_scores = model_selection.cross_val_score(svm_model, X, y, cv=5)
# 9. Print a Classification Report
print(metrics.classification_report(y_test, svm_model.predict(X_test)))
# 10. Create a Preprocessing and Model Pipeline
pipeline_model = pipeline.Pipeline([('scaler', preprocessing.StandardScaler()), ('svm', svm.SVC())]).fit(X_train, y_train)
```

## Suggested improvements

```python
# integrate PCA into the pipeline to ensure it is applied correctly during training and testing:
pipeline_model = pipeline.Pipeline([
    ('scaler', preprocessing.StandardScaler()),
    ('pca', decomposition.PCA(n_components=2)),
    ('svm', svm.SVC())
])
pipeline_model.fit(X_train, y_train)
# use scaled data
pipeline_model = pipeline.Pipeline([
    ('scaler', preprocessing.StandardScaler()),
    ('svm', svm.SVC())
])
cv_scores = model_selection.cross_val_score(pipeline_model, X, y, cv=5)
print(f"Cross-validation scores: {cv_scores}")
```

## Fully-refined code

```python
from sklearn import datasets, model_selection, preprocessing, metrics, svm, decomposition, pipeline
from sklearn.model_selection import train_test_split

# 1. Load the Iris Dataset
X, y = datasets.load_iris(return_X_y=True)

# 2. Split Data into Train and Test Sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 3. Standardize Features
scaler = preprocessing.StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 4. Reduce Dimensionality with PCA
pca = decomposition.PCA(n_components=2)
X_train_reduced = pca.fit_transform(X_train_scaled)
X_test_reduced = pca.transform(X_test_scaled)

# 5. Train an SVM Classifier
svm_model = svm.SVC(kernel='linear', C=1.0, random_state=42).fit(X_train_reduced, y_train)

# 6. Generate a Confusion Matrix
conf_matrix = metrics.confusion_matrix(y_test, svm_model.predict(X_test_reduced))
print("Confusion Matrix:\n", conf_matrix)

# 7. Perform Cross-Validation
cv_scores = model_selection.cross_val_score(svm_model, X_train_reduced, y_train, cv=5)
print(f"Cross-validation scores: {cv_scores}")

# 8. Print a Classification Report
print(metrics.classification_report(y_test, svm_model.predict(X_test_reduced)))

# 9. Create a Preprocessing and Model Pipeline
pipeline_model = pipeline.Pipeline([
    ('scaler', preprocessing.StandardScaler()),
    ('pca', decomposition.PCA(n_components=2)),
    ('svm', svm.SVC())
])

# 10. Train the model using the pipeline
pipeline_model.fit(X_train, y_train)
y_pred = pipeline_model.predict(X_test)
from sklearn.metrics import classification_report, accuracy_score
print("Accuracy:", accuracy_score(y_test, y_pred))
print("Classification Report:\n", classification_report(y_test, y_pred))
```

from which we get a 90% accuracy.

## URLs

- scikit-learn documentation, <https://scikit-learn.org/stable/index.html>
- Intro to Machine Learning, <https://www.kaggle.com/learn/intro-to-machine-learning>
- Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow, 3e, <https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/>

```mermaid
graph TD
    subgraph Layer_L1[Layer L1]
        x1[x1]
        x2[x2]
        x3[x3]
        x4[x4]
        x5[x5]
        x6[x6]
        b1[+1]
    end

    subgraph Layer_L2[Layer L2]
        h1[h]
        h2[h]
        h3[h]
        b2[+1]
    end

    subgraph Layer_L3[Layer L3]
        y1[\hat{x1}]
        y2[\hat{x2}]
        y3[\hat{x3}]
        y4[\hat{x4}]
        y5[\hat{x5}]
        y6[\hat{x6}]
    end

    x1 --> h1
    x1 --> h2
    x1 --> h3

    x2 --> h1
    x2 --> h2
    x2 --> h3

    x3 --> h1
    x3 --> h2
    x3 --> h3

    x4 --> h1
    x4 --> h2
    x4 --> h3

    x5 --> h1
    x5 --> h2
    x5 --> h3

    x6 --> h1
    x6 --> h2
    x6 --> h3

    b1 --> h1
    b1 --> h2
    b1 --> h3

    h1 --> y1
    h1 --> y2
    h1 --> y3
    h1 --> y4
    h1 --> y5
    h1 --> y6

    h2 --> y1
    h2 --> y2
    h2 --> y3
    h2 --> y4
    h2 --> y5
    h2 --> y6

    h3 --> y1
    h3 --> y2
    h3 --> y3
    h3 --> y4
    h3 --> y5
    h3 --> y6

    b2 --> y1
    b2 --> y2
    b2 --> y3
    b2 --> y4
    b2 --> y5
    b2 --> y6
```

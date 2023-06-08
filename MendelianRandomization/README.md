To allow for OR

```
4i7c47
<               generic_plot <- ggplot(data = NULL, aes(x = Bx, y = By, text = object@snps)) +
---
>               generic_plot <- ggplot(data = NULL, aes(x = Bx, y = exp(By), text = object@snps)) +
53c53
<                       
---
>                       axis.line = element_line(linewidth = 1, colour = "grey"),
61c61
<                 geom_hline(yintercept=0) + 
---
>                 geom_hline(yintercept=1) + 
75c75
<                   geom_errorbar(aes(ymin = By - qnorm(0.975)*Byse, ymax = By + qnorm(0.975)*Byse), colour = "blue") +
---
>                   geom_errorbar(aes(ymin = exp(By - qnorm(0.975)*Byse), ymax = exp(By + qnorm(0.975)*Byse)), colour = "blue") +
87c87
<                 generic_plot <- generic_plot + geom_abline(intercept = 0, 
---
>                 generic_plot <- generic_plot + geom_abline(intercept = 1, 
```

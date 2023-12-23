为何 FullCalendar 号称前端最强日历组件？
首发2023-12-15 06:20·高级前端进阶
大家好，很高兴又见面了，我是"高级前端进阶"，由我带着大家一起关注前端前沿、深入前端底层技术，大家一起进步，也欢迎大家关注、点赞、收藏、转发!


1.什么是 FullCalendar
FullCalendar 是一个用于创建日历界面的 JavaScript 开源库，支持全尺寸拖放（Full-sized drag & drop），同时具有适用于 React 和许多其他框架的适配器，比如：React、Vue、Angular 、Web Component等以及一流的 TypeScript 支持。

FullCalendar 目前非常受欢迎 ，除了易于使用之外还具有许多内置功能和用于充分定制的插件，而官方提供的插件数量已经达到了 25+。

目前 FullCalendar 在 Github 上通过 MIT 协议开源，有超过 17.3k 的 star、3.6k 的 fork、项目依赖量 63.8k、代码贡献者 100+、妥妥的前端优质开源项目。

2.为什么要 FullCalendar
2.1 不同视图支持
FullCalendar 库提供各种日历视图，例如：每月、每周和每天，还具有 TimeGrid 、 DayGrid 、TimeLine、Multi-Month Stack 等等视图模式，同时允许自定义视图，非常适合构建日程安排界面。

比如下面的代码设置了视图模式为 dayGridMonth：

import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

const calendar = new Calendar(calendarEl, {
  plugins: [dayGridPlugin],
  initialView: 'dayGridMonth',
});
页面渲染视图如下：


2.2 丰富的插件系统
FullCalendar 具有多种用于添加额外功能的插件。

插件系统很有用，因为开发者不需要下载整个代码库，但可以选择要包含的插件。 这样做可以缩小代码库的大小，并使管理依赖项变得更容易。

一些主流的插件包括：

@fullcalendar/interaction：提供点击、触摸、拖动交互。
@fullcalendar/daygrid：提供每月、每日和每周的日历视图。
@fullcalendar/timegrid：提供时间网格视图。
@fullcalendar/list：提供简化的列表视图。
@fullcalendar/vue3：支持 Vue3
@fullcalendar/vue：支持 Vue2
@fullcalendar/angular：支持 Angular 组件
@fullcalendar/react：支持 React 组件
下面是在 Vue3 中使用 FullCalendar 的代码示例：

<script>
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
export default {
  components: {
    FullCalendar
     // make the <FullCalendar> tag available
  },
  data() {
    return {
      calendarOptions: {
        plugins: [ dayGridPlugin, interactionPlugin ],
        initialView: 'dayGridMonth'
      }
    }
  }
}
</script>
<template>
  <FullCalendar :options="calendarOptions" />
</template>
3.使用 FullCalendar
3.1 基础用法
首先，需要安装核心 npm 包：

yarn add @fullcalendar/daygrid @fullcalendar/react
接下来，添加 FullCalendar 组件并包含日期网格插件：

import FullCalendar from '@fullcalendar/react';
import daygridPlugin from '@fullcalendar/daygrid';

export const MyCalendar = () => {
  return (
    <div>
      <FullCalendar plugins={[daygridPlugin]} />
    </div>
  );
};
下面是设置以后的基础视图：


接下来可以自定义顶部工具栏并添加每周和每日视图。 FullCalendar 提供了 headerToolbar 属性，开发者可以使用它来选择想要查看的控件：

<FullCalendar
  headerToolbar={{
    start: 'today prev next',
    end: 'dayGridMonth dayGridWeek dayGridDay',
  }}
  plugins={[daygridPlugin]}
  views={['dayGridMonth', 'dayGridWeek', 'dayGridDay']}
/>
headerToolbar 对象接受 start, center、end 字段 ， 每个字段都必须是可以包含标题、上一个、下一个、上一年、下一年、今天和日历视图名称（如 dayGridMonth）的字符串。

开发者可以按照想要的任何顺序排列这些字段，FullCalendar 将正确的渲染。


3.2 添加事件交互
为了给日历组件添加交互，需要首先添加 @fullcalendar/interaction 插件：

yarn add @fullcalendar/interaction
同时需要将 editable 和 selectable 属性设置为 true 并将事件处理程序放置在 events 属性中。

import FullCalendar from '@fullcalendar/react';
import daygridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import { useState } from 'react';
import { v4 as uuid } from 'uuid';

export const MyCalendar = () => {
  const [events, setEvents] = useState([]);

  const handleSelect = (info) => {
    const { start, end } = info;
    const eventNamePrompt = prompt('Enter, event name');
    if (eventNamePrompt) {
      setEvents([
        ...events,
        {
          start,
          end,
          title: eventNamePrompt,
          id: uuid(),
        },
      ]);
    }
  };

  return (
    <div>
      <FullCalendar
        editable
        selectable
        events={events}
        // 事件处理
        select={handleSelect}
        headerToolbar={{
          start: 'today prev next',
          end: 'dayGridMonth dayGridWeek dayGridDay',
        }}
        plugins={[daygridPlugin, interactionPlugin]}
        views={['dayGridMonth', 'dayGridWeek', 'dayGridDay']}
      />
    </div>
  );
};
以上代码首先添加了一个 handleSelect 回调，其接受 info 对象作为参数，该对象包含有关用户选择日期的信息。

Prompt() 函数向用户询问事件标题并创建一个包含开始、结束、标题和 ID 的新事件。而 id 属性需要是唯一的字符串，而这里引入了 uuid 三方库。

要添加编辑事件，可以遵循与上面类似的模式，只需要使用 eventClick 属性，而拖放操作则可以使用 eventChange 。

参考资料
https://github.com/fullcalendar/fullcalendar

https://isamatov.com/react-fullcalendar-tutorial/

https://fullcalendar.io/docs/plugin-index

https://fullcalendar.io/docs/vue

https://medevel.com/os-js-calendar/

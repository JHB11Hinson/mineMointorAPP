import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { McLineChart, Options } from '@mcui/mccharts';
import { DustItem } from '../model/DustModel';


@HMRouter({
  pageUrl: 'DustDetailPage',
})

@Component
export struct DustDetailPage {
  @State dustItem: DustItem | null = null;


  private timer: number = 0;

  @State defOption: Options = new Options({
    xAxis: {
      data: ['10:00', '10:05', '10:10', '10:15', '10:20', '10:25', '当前']
    },
    yAxis: {
      name: '浓度(μg/m³)'
    },
    series: [
      {
        name: 'PM2.5',
        data: [30, 42, 35, 50, 45, 60, 0]
      },
      {
        name: 'PM10',
        data: [60, 75, 68, 90, 85, 110, 0]
      }
    ]
  });

  aboutToAppear() {
    const params = HMRouterMgr.getCurrentParam();
    if (params) {
      this.dustItem = params as DustItem;
      // Ensure dustItem is not null before accessing properties
      if (this.dustItem) {
        this.updateChartData(this.dustItem.pm25, this.dustItem.pm10);
      }
    }

    this.timer = setInterval(() => {
      this.simulateRealtimeData();
    }, 2000);
  }

  aboutToDisappear() {
    clearInterval(this.timer);
  }

  updateChartData(pm25: number, pm10: number) {
    const series = this.defOption.series;
    // Check if series exists and has enough length
    if (!series || series.length < 2) {
      return;
    }


    // 1. Get the raw data. The library types this as (string|number|object)[] | undefined
    const rawPm25Data = series[0].data;
    const rawPm10Data = series[1].data;

    // 2. Safety check
    if (!rawPm25Data || !rawPm10Data) {
      return;
    }

    // 3. Type Assertion (AS keyword)
    // We tell ArkTS: "Trust me, these are arrays of numbers"
    // This fixes: "Type ... must have a [Symbol. iterator]"
    const pm25Arr = rawPm25Data as number[];
    const pm10Arr = rawPm10Data as number[];

    // 4. Clone using .slice() instead of Spread (...)
    // This fixes: "It is possible to spread only arrays..."
    let newPm25Data: number[] = pm25Arr.slice();
    let newPm10Data: number[] = pm10Arr.slice();

    // Update the last element
    if (newPm25Data.length > 0) {
      newPm25Data[newPm25Data.length - 1] = pm25;
    }
    if (newPm10Data.length > 0) {
      newPm10Data[newPm10Data.length - 1] = pm10;
    }

    // Reassign back to the series
    series[0].data = newPm25Data;
    series[1].data = newPm10Data;

  }

  simulateRealtimeData() {
    if (!this.dustItem) return;

    const random = Math.floor(Math.random() * 10) - 5;
    let newPm25 = this.dustItem.pm25 + random;
    let newPm10 = this.dustItem.pm10 + random;

    if (newPm25 < 0) newPm25 = 0;


    this.dustItem.pm25 = newPm25;
    this.dustItem.pm10 = newPm10;

    // Update chart
    this.updateChartData(newPm25, newPm10);
  }

  build() {
    Column() {
      // Title Bar
      Row() {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(24).height(24)
          .onClick(() => HMRouterMgr.pop())
        Text((this.dustItem?.area ?? '') + ' - 实时监控') // Handle possible null
          .fontSize(18).fontWeight(FontWeight.Bold).margin({ left: 10 })
      }
      .width('100%').padding(16)

      // Chart Area
      Column() {
        Text('空气质量趋势图').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 20 })

        McLineChart({
          options: this.defOption
        }).height('40%')
      }
      .width('100%').padding(10)

      // Detail Cards
      Row() {
        Column() {
          Text('PM2.5').fontColor('#999')
          Text(`${this.dustItem?.pm25 ?? 0}`).fontSize(24).fontWeight(FontWeight.Bold)
        }.layoutWeight(1)

        Column() {
          Text('PM10').fontColor('#999')
          Text(`${this.dustItem?.pm10 ?? 0}`).fontSize(24).fontWeight(FontWeight.Bold)
        }.layoutWeight(1)

        Column() {
          Text('空气等级').fontColor('#999')
          Text(this.dustItem?.status === 0 ? '优' : '差')
            .fontSize(24)
            .fontColor(this.dustItem?.status === 0 ? '#52C41A' : '#FF4D4F')
            .fontWeight(FontWeight.Bold)
        }.layoutWeight(1)
      }
      .width('90%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 10, color: '#1A000000' })
      .margin({ top: 20 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F7F9')
  }
}
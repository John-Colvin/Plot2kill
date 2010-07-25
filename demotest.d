/**These are demos/tests for Plot2Kill.  Most of them require my dstats lib.
 * dstats is not a dependency of Plot2Kill, except for these demos.  I chose to
 * use dstats-related demos becuase statistics-related plots is where I got
 * many of my use cases from, and Plot2Kill probably would work nicely with
 * dstats.
 *
 * Copyright (C) 2010 David Simcha
 *
 * License:
 *
 * Boost Software License - Version 1.0 - August 17th, 2003
 *
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 *
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
import std.conv, std.contracts, std.algorithm, std.typecons,
    std.traits, std.math, std.array, std.range, std.functional, core.thread,
    std.stdio;

// Uncomment this to compile/run the tests.
//version = test;


// These aren't formal unittests, but they exercise the basic functionality.
// Most require dstats.
version(test) {
import plot2kill.all, plot2kill.util;

version(gtk) {
    import gtk.Main, cairo.SvgSurface, cairo.Context;
}
import dstats.all, std.stdio;
void main(string[] args)
{
    version(gtk) {
        Main.init(null);
        Main.init(args);
    }

    // This one tests zooming in heavily, specifically on the tail of a distrib.
    auto histRand = Histogram(
        randArray!rNorm(5_000, 0, 1), 100, -5, 5, OutOfBounds.Ignore);
    histRand.put(
        Histogram(randArray!rNorm(5_000, 0, 1), 100, -5, 5, OutOfBounds.Ignore)
    );
    auto histLine = ContinuousFunction(
        parametrize!normalPDF(0, 1), -5, 5);
    histRand.scaleDistributionFunction(histLine);
    histLine.lineColor = getColor(255, 0, 0);
    histLine.lineWidth = 3;

    auto hist = Figure(histRand, histLine);
    hist.addLines(
        FigureLine(-2, 0, -2, hist.topMost, getColor(128, 0, 0), 2),
        FigureLine(2, 0, 2, hist.topMost, getColor(128, 0, 0), 2)
    );

    hist.title = "Normal Distrib.";
    hist.xLabel = "Random Variable";
    hist.yLabel = "Count";

    version(gtk) {
        hist.saveToFile("foo.svg");
    } else {
        hist.saveToFile("foo.bmp");
    }

    hist.showAsMain();

    auto errs = [0.1, 0.2, 0.3, 0.4];
    auto linesWithErrors =
        LineGraph([1,2,3,4], [1,2,3,8], errs, errs);
    linesWithErrors.lineColor = getColor(255, 0, 0);
    auto linesWithErrorsFig = linesWithErrors.toFigure;
    linesWithErrorsFig.title = "Error Bars";
 //   linesWithErrorsFig.showAsMain();

    auto binomExact =
        DiscreteFunction(parametrize!binomialPMF(8, 0.5), 0, 8);
    auto binomApprox =
        ContinuousFunction(parametrize!normalPDF(4, sqrt(2.0)), -1, 9, 100);
    binomApprox.lineWidth = 2;
    auto binom = Figure(binomExact, binomApprox);
    binom.title = "Binomial";
    binom.xLabel = "N Successes";
    binom.yLabel = "Probability";
    binom.xTickLabels(array(iota(0, 9, 1)));
    binom.xLim(0, 8);
  //  binom.showAsMain();

    auto scatter = ScatterPlot(
        randArray!rNorm(100, 0, 1),
        randArray!rNorm(100, 0, 1)
    ).pointColor(getColor(255, 0, 255)).toFigure;
    scatter.xLim(-2, 2);
    scatter.yLim(-2, 2);
    scatter.verticalGrid = true;
    scatter.horizontalGrid = true;
 //   scatter.showAsMain();

    auto bars = BarPlot([1,2,3], [8,7,3], 0.5, [1,2,4], [1,2,4]);
    auto barFig = bars.toFigure;
    barFig.xTickLabels(bars.centers, ["Plan A", "Plan B", "Plan C"]);
    barFig.title = "Useless Plans";
    barFig.yLabel = "Screwedness";
 //   barFig.showAsMain();

    auto qq = QQPlot(
        randArray!rStudentT(100, 7),
        parametrize!invNormalCDF(0, 1)
    ).toFigure;
    qq.title = "Normal Vs. Student's T w/ 7 D.F.";
    qq.xLabel = "Normal";
    qq.yLabel = "Student's T";
  //  qq.showAsMain();

    auto frqHist = FrequencyHistogram(
        randArray!rNorm(100_000, 0, 1), 100).toFigure;
    frqHist.xLim(-2.5, 2.5);

    auto uniqueHist = UniqueHistogram(
        randArray!rBinomial(10_000, 8, 0.5)
    );
    uniqueHist.histType = HistType.Probability;
    uniqueHist.barColor = getColor(0, 200, 0);
    auto uniqueHistFig = uniqueHist.toLabeledFigure;
    uniqueHistFig.title = "Unique Histogram";
 //   uniqueHistFig.showAsMain();

    auto heatScatter = HeatScatter(100, 100, -6, 6, -5, 5);
    heatScatter.boundsBehavior = OutOfBounds.Ignore;
    foreach(i; 0..500_000) {
        auto num1 = rNorm(-2, 1);
        auto num2 = rNorm(1, 1);
        num1 += num2;
        heatScatter.put(num1, num2);
    }
    auto a1 = randArray!rNorm(500_000, -2, 1);
    auto a2 = randArray!rNorm(500_000,  1, 1);
    a1[] += a2[];
    heatScatter.put(
        HeatScatter(a1, a2, 100, 100, -6, 6, -5, 5, OutOfBounds.Ignore)
    );

    heatScatter
        .coldColor(getColor(255, 255, 255))
        .hotColor(getColor(0, 0, 0));
    auto heatScatterFig = heatScatter.toFigure
        .xLim(-4, 2)
        .yLim(-2, 4)
        .title("2D Histogram")
        .xLabel("Normal(-2, 1) + Y[i]")
        .yLabel("Normal(1, 1)");

    version(gtk) {
        heatScatterFig.saveToFile("bar.png", "png", 640, 480);
    } else {
        heatScatterFig.saveToFile("bar.bmp", 640, 480);
    }

  heatScatterFig.showAsMain();

    version(gtk) {
        enum string subplotY = "Pretty Rotated Text";
        enum string titleStuff = "Plot2Kill GTK Demo  (Programmatically " ~
            "saved, no longer a screenshot)";
    } else version(dfl) {
        enum string subplotY = "Ugly Columnar Text";
        enum string titleStuff = "Plot2Kill DFL Demo";

    }

    auto sp = Subplot(3, 3)
        .addFigure(hist, 0, 0)
        .addFigure(binom, 0, 1)
        .addFigure(linesWithErrorsFig, 1, 0)
        .addFigure(scatter, 1, 1)
        .addFigure(barFig, 0, 2)
        .addFigure(qq, 1, 2)
        .addFigure(frqHist, 2, 0)
        .addFigure(uniqueHistFig, 2, 1)
        .addFigure(heatScatterFig, 2, 2)
        .title(titleStuff)
        .yLabel(subplotY)
        .xLabel("Boring X-Axis Label");

    version(gtk) {
        sp.saveToFile("sp.png", 1280, 1024);
        sp.saveToFile("sp.pdf", 1280, 1024);
        sp.saveToFile("sp.svg", 1280, 1024);

    } else {
        sp.saveToFile("sp.bmp", 1280, 1024);
    }
    sp.showAsMain();

}}

/**This file contains the GUI-agnostic base functionality of Figure and Subplot.
 * FigureBase inherits from it in all GUI ports.
 *
 * Copyright (C) 2010-2011 David Simcha
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
module plot2kill.guiagnosticbase;

version(dfl) {
    import plot2kill.dflwrapper;
} else {
    import plot2kill.gtkwrapper;
}

/**This is the base class for all GUI-specific FigureBase objects, and
 * contains functionality common to Figures and Subplots across all GUIs.
 */
abstract class GuiAgnosticBase {
protected:
    // These control where on the drawing object the figure is drawn.
    double xOffset = 0;
    double yOffset = 0;

    // These control the width and height that we assume we're drawing to.
    double _width = 0;
    double _height = 0;

    // Due to bugs in DMD, we can't make the derived classes go through the
    // official API yet.
    string _title;
    string _xLabel;
    string _yLabel;
    Font _titleFont;
    Font _xLabelFont;
    Font _yLabelFont;

public:

    abstract void drawImpl() {}
    abstract int defaultWindowWidth();
    abstract int defaultWindowHeight();
    abstract int minWindowWidth();
    abstract int minWindowHeight();

    final double width()  {
        return _width;
    }

    final double height()  {
        return _height;
    }

    ///
    final string title()() {
        return _title;
    }

    ///
    final This title(this This)(string newTitle) {
        _title = newTitle;
        return cast(This) this;
    }

    ///
    final string xLabel()() {
        return _xLabel;
    }

    ///
    final This xLabel(this This)(string newLabel) {
        _xLabel = newLabel;
        return cast(This) this;
    }

    ///
    final string yLabel()() {
        return _yLabel;
    }

    ///
    final This yLabel(this This)(string newLabel) {
        _yLabel = newLabel;
        return cast(This) this;
    }

    ///
    final Font titleFont()() {
        return _titleFont;
    }

    ///
    final This titleFont(this This)(Font newTitleFont) {
        _titleFont = newTitleFont;
        return cast(This) this;
    }

    ///
    final Font xLabelFont()() {
        return _xLabelFont;
    }

    ///
    final This xLabelFont(this This)(Font newLabelFont) {
        _xLabelFont = newLabelFont;
        return cast(This) this;
    }

    ///
    final Font yLabelFont()() {
        return _yLabelFont;
    }

    ///
    final This yLabelFont(this This)(Font newLabelFont) {
        _yLabelFont = newLabelFont;
        return cast(This) this;
    }
}



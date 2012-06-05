/*
** License Applicability. Except to the extent portions of this file are
** made subject to an alternative license as permitted in the SGI Free
** Software License B, Version 1.0 (the "License"), the contents of this
** file are subject only to the provisions of the License. You may not use
** this file except in compliance with the License. You may obtain a copy
** of the License at Silicon Graphics, Inc., attn: Legal Services, 1600
** Amphitheatre Parkway, Mountain View, CA 94043-1351, or at:
** 
** http://oss.sgi.com/projects/FreeB
** 
** Note that, as provided in the License, the Software is distributed on an
** "AS IS" basis, with ALL EXPRESS AND IMPLIED WARRANTIES AND CONDITIONS
** DISCLAIMED, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES AND
** CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A
** PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
** 
** Original Code. The Original Code is: OpenGL Sample Implementation,
** Version 1.2.1, released January 26, 2000, developed by Silicon Graphics,
** Inc. The Original Code is Copyright (c) 1991-2000 Silicon Graphics, Inc.
** Copyright in any portions created by third parties is as indicated
** elsewhere herein. All Rights Reserved.
** 
** Additional Notice Provisions: The application programming interfaces
** established by SGI in conjunction with the Original Code are The
** OpenGL(R) Graphics System: A Specification (Version 1.2.1), released
** April 1, 1999; The OpenGL(R) Graphics System Utility Library (Version
** 1.3), released November 4, 1998; and OpenGL(R) Graphics with the X
** Window System(R) (Version 1.3), released October 19, 1998. This software
** was created using the OpenGL(R) version 1.2.1 Sample Implementation
** published by SGI, but has not been independently verified as being
** compliant with the OpenGL(R) version 1.2.1 Specification.
*/
module org.opengl.glu;

import org.opengl.gl;

version = GLU_EXT_object_space_tess;
version = GLU_EXT_nurbs_tessellator;

immutable GLboolean GLU_FALSE = 0;
immutable GLboolean GLU_TRUE  = 1;

version = GLU_VERSION_1_1;
version = GLU_VERSION_1_2;
version = GLU_VERSION_1_3;

immutable GLenum GLU_VERSION    = 100800;
immutable GLenum GLU_EXTENSIONS = 100801;

immutable GLenum GLU_INVALID_ENUM      = 100900;
immutable GLenum GLU_INVALID_VALUE     = 100901;
immutable GLenum GLU_OUT_OF_MEMORY     = 100902;
immutable GLenum GLU_INVALID_OPERATION = 100904;

immutable GLenum GLU_OUTLINE_POLYGON = 100240;
immutable GLenum GLU_OUTLINE_PATCH   = 100241;

immutable GLenum GLU_NURBS_ERROR              = 100103;
immutable GLenum GLU_ERROR                    = 100103;
immutable GLenum GLU_NURBS_BEGIN              = 100164;
immutable GLenum GLU_NURBS_BEGIN_EXT          = 100164;
immutable GLenum GLU_NURBS_VERTEX             = 100165;
immutable GLenum GLU_NURBS_VERTEX_EXT         = 100165;
immutable GLenum GLU_NURBS_NORMAL             = 100166;
immutable GLenum GLU_NURBS_NORMAL_EXT         = 100166;
immutable GLenum GLU_NURBS_COLOR              = 100167;
immutable GLenum GLU_NURBS_COLOR_EXT          = 100167;
immutable GLenum GLU_NURBS_TEXTURE_COORD      = 100168;
immutable GLenum GLU_NURBS_TEX_COORD_EXT      = 100168;
immutable GLenum GLU_NURBS_END                = 100169;
immutable GLenum GLU_NURBS_END_EXT            = 100169;
immutable GLenum GLU_NURBS_BEGIN_DATA         = 100170;
immutable GLenum GLU_NURBS_BEGIN_DATA_EXT     = 100170;
immutable GLenum GLU_NURBS_VERTEX_DATA        = 100171;
immutable GLenum GLU_NURBS_VERTEX_DATA_EXT    = 100171;
immutable GLenum GLU_NURBS_NORMAL_DATA        = 100172;
immutable GLenum GLU_NURBS_NORMAL_DATA_EXT    = 100172;
immutable GLenum GLU_NURBS_COLOR_DATA         = 100173;
immutable GLenum GLU_NURBS_COLOR_DATA_EXT     = 100173;
immutable GLenum GLU_NURBS_TEXTURE_COORD_DATA = 100174;
immutable GLenum GLU_NURBS_TEX_COORD_DATA_EXT = 100174;
immutable GLenum GLU_NURBS_END_DATA           = 100175;
immutable GLenum GLU_NURBS_END_DATA_EXT       = 100175;

immutable GLenum GLU_NURBS_ERROR1  = 100251;
immutable GLenum GLU_NURBS_ERROR2  = 100252;
immutable GLenum GLU_NURBS_ERROR3  = 100253;
immutable GLenum GLU_NURBS_ERROR4  = 100254;
immutable GLenum GLU_NURBS_ERROR5  = 100255;
immutable GLenum GLU_NURBS_ERROR6  = 100256;
immutable GLenum GLU_NURBS_ERROR7  = 100257;
immutable GLenum GLU_NURBS_ERROR8  = 100258;
immutable GLenum GLU_NURBS_ERROR9  = 100259;
immutable GLenum GLU_NURBS_ERROR10 = 100260;
immutable GLenum GLU_NURBS_ERROR11 = 100261;
immutable GLenum GLU_NURBS_ERROR12 = 100262;
immutable GLenum GLU_NURBS_ERROR13 = 100263;
immutable GLenum GLU_NURBS_ERROR14 = 100264;
immutable GLenum GLU_NURBS_ERROR15 = 100265;
immutable GLenum GLU_NURBS_ERROR16 = 100266;
immutable GLenum GLU_NURBS_ERROR17 = 100267;
immutable GLenum GLU_NURBS_ERROR18 = 100268;
immutable GLenum GLU_NURBS_ERROR19 = 100269;
immutable GLenum GLU_NURBS_ERROR20 = 100270;
immutable GLenum GLU_NURBS_ERROR21 = 100271;
immutable GLenum GLU_NURBS_ERROR22 = 100272;
immutable GLenum GLU_NURBS_ERROR23 = 100273;
immutable GLenum GLU_NURBS_ERROR24 = 100274;
immutable GLenum GLU_NURBS_ERROR25 = 100275;
immutable GLenum GLU_NURBS_ERROR26 = 100276;
immutable GLenum GLU_NURBS_ERROR27 = 100277;
immutable GLenum GLU_NURBS_ERROR28 = 100278;
immutable GLenum GLU_NURBS_ERROR29 = 100279;
immutable GLenum GLU_NURBS_ERROR30 = 100280;
immutable GLenum GLU_NURBS_ERROR31 = 100281;
immutable GLenum GLU_NURBS_ERROR32 = 100282;
immutable GLenum GLU_NURBS_ERROR33 = 100283;
immutable GLenum GLU_NURBS_ERROR34 = 100284;
immutable GLenum GLU_NURBS_ERROR35 = 100285;
immutable GLenum GLU_NURBS_ERROR36 = 100286;
immutable GLenum GLU_NURBS_ERROR37 = 100287;

immutable GLenum GLU_AUTO_LOAD_MATRIX      = 100200;
immutable GLenum GLU_CULLING               = 100201;
immutable GLenum GLU_SAMPLING_TOLERANCE    = 100203;
immutable GLenum GLU_DISPLAY_MODE          = 100204;
immutable GLenum GLU_PARAMETRIC_TOLERANCE  = 100202;
immutable GLenum GLU_SAMPLING_METHOD       = 100205;
immutable GLenum GLU_U_STEP                = 100206;
immutable GLenum GLU_V_STEP                = 100207;
immutable GLenum GLU_NURBS_MODE            = 100160;
immutable GLenum GLU_NURBS_MODE_EXT        = 100160;
immutable GLenum GLU_NURBS_TESSELLATOR     = 100161;
immutable GLenum GLU_NURBS_TESSELLATOR_EXT = 100161;
immutable GLenum GLU_NURBS_RENDERER        = 100162;
immutable GLenum GLU_NURBS_RENDERER_EXT    = 100162;

immutable GLenum GLU_OBJECT_PARAMETRIC_ERROR     = 100208;
immutable GLenum GLU_OBJECT_PARAMETRIC_ERROR_EXT = 100208;
immutable GLenum GLU_OBJECT_PATH_LENGTH          = 100209;
immutable GLenum GLU_OBJECT_PATH_LENGTH_EXT      = 100209;
immutable GLenum GLU_PATH_LENGTH                 = 100215;
immutable GLenum GLU_PARAMETRIC_ERROR            = 100216;
immutable GLenum GLU_DOMAIN_DISTANCE             = 100217;

immutable GLenum GLU_MAP1_TRIM_2 = 100210;
immutable GLenum GLU_MAP1_TRIM_3 = 100211;

immutable GLenum GLU_POINT      = 100010;
immutable GLenum GLU_LINE       = 100011;
immutable GLenum GLU_FILL       = 100012;
immutable GLenum GLU_SILHOUETTE = 100013;

immutable GLenum GLU_SMOOTH = 100000;
immutable GLenum GLU_FLAT   = 100001;
immutable GLenum GLU_NONE   = 100002;

immutable GLenum GLU_OUTSIDE = 100020;
immutable GLenum GLU_INSIDE  = 100021;

immutable GLenum GLU_TESS_BEGIN          = 100100;
immutable GLenum GLU_BEGIN               = 100100;
immutable GLenum GLU_TESS_VERTEX         = 100101;
immutable GLenum GLU_VERTEX              = 100101;
immutable GLenum GLU_TESS_END            = 100102;
immutable GLenum GLU_END                 = 100102;
immutable GLenum GLU_TESS_ERROR          = 100103;
immutable GLenum GLU_TESS_EDGE_FLAG      = 100104;
immutable GLenum GLU_EDGE_FLAG           = 100104;
immutable GLenum GLU_TESS_COMBINE        = 100105;
immutable GLenum GLU_TESS_BEGIN_DATA     = 100106;
immutable GLenum GLU_TESS_VERTEX_DATA    = 100107;
immutable GLenum GLU_TESS_END_DATA       = 100108;
immutable GLenum GLU_TESS_ERROR_DATA     = 100109;
immutable GLenum GLU_TESS_EDGE_FLAG_DATA = 100110;
immutable GLenum GLU_TESS_COMBINE_DATA   = 100111;

immutable GLenum GLU_CW       = 100120;
immutable GLenum GLU_CCW      = 100121;
immutable GLenum GLU_INTERIOR = 100122;
immutable GLenum GLU_EXTERIOR = 100123;
immutable GLenum GLU_UNKNOWN  = 100124;

immutable GLenum GLU_TESS_WINDING_RULE  = 100140;
immutable GLenum GLU_TESS_BOUNDARY_ONLY = 100141;
immutable GLenum GLU_TESS_TOLERANCE     = 100142;

immutable GLenum GLU_TESS_ERROR1                = 100151;
immutable GLenum GLU_TESS_ERROR2                = 100152;
immutable GLenum GLU_TESS_ERROR3                = 100153;
immutable GLenum GLU_TESS_ERROR4                = 100154;
immutable GLenum GLU_TESS_ERROR5                = 100155;
immutable GLenum GLU_TESS_ERROR6                = 100156;
immutable GLenum GLU_TESS_ERROR7                = 100157;
immutable GLenum GLU_TESS_ERROR8                = 100158;
immutable GLenum GLU_TESS_MISSING_BEGIN_POLYGON = 100151;
immutable GLenum GLU_TESS_MISSING_BEGIN_CONTOUR = 100152;
immutable GLenum GLU_TESS_MISSING_END_POLYGON   = 100153;
immutable GLenum GLU_TESS_MISSING_END_CONTOUR   = 100154;
immutable GLenum GLU_TESS_COORD_TOO_LARGE       = 100155;
immutable GLenum GLU_TESS_NEED_COMBINE_CALLBACK = 100156;

immutable GLenum GLU_TESS_WINDING_ODD         = 100130;
immutable GLenum GLU_TESS_WINDING_NONZERO     = 100131;
immutable GLenum GLU_TESS_WINDING_POSITIVE    = 100132;
immutable GLenum GLU_TESS_WINDING_NEGATIVE    = 100133;
immutable GLenum GLU_TESS_WINDING_ABS_GEQ_TWO = 100134;

immutable GLenum GL_LOGIC_OP = GL_INDEX_LOGIC_OP;
immutable GLenum GL_TEXTURE_COMPONENTS = GL_TEXTURE_INTERNAL_FORMAT;

struct GLUnurbs;
struct GLUquadric;
struct GLUtesselator;

alias GLUnurbs GLUnurbsObj;
alias GLUquadric GLUquadricObj;
alias GLUtesselator GLUtesselatorObj;
alias GLUtesselator GLUtriangulatorObj;

immutable GLdouble GLU_TESS_MAX_COORD = 1.0e150;

extern (System)
{
	void gluBeginCurve(GLUnurbs* nurb);
	void gluBeginPolygon( GLUtesselator* tess);
	void gluBeginSurface(GLUnurbs* nurb);
	void gluBeginTrim(GLUnurbs* nurb);
	GLint gluBuild1DMipmapLevels(GLenum target, GLint internalFormat, GLsizei width, GLenum format, GLenum type, GLint level, GLint base, GLint max, const(void)* data);
	GLint gluBuild1DMipmaps(GLenum target, GLint internalFormat, GLsizei width, GLenum format, GLenum type, const(void)* data);
	GLint gluBuild2DMipmapLevels(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, GLint level, GLint base, GLint max, const(void)* data);
	GLint gluBuild2DMipmaps(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLenum format, GLenum type, const(void)* data);
	GLint gluBuild3DMipmapLevels(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLint level, GLint base, GLint max, const(void)* data);
	GLint gluBuild3DMipmaps(GLenum target, GLint internalFormat, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* data);
	GLboolean gluCheckExtension(const(GLubyte)* extName, const(GLubyte)* extString);
	void gluCylinder(GLUquadric* quad, GLdouble base, GLdouble top, GLdouble height, GLint slices, GLint stacks);
	void gluDeleteNurbsRenderer(GLUnurbs* nurb);
	void gluDeleteQuadric(GLUquadric* quad);
	void gluDeleteTess(GLUtesselator* tess);
	void gluDisk(GLUquadric* quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops);
	void gluEndCurve(GLUnurbs* nurb);
	void gluEndPolygon(GLUtesselator* tess);
	void gluEndSurface(GLUnurbs* nurb);
	void gluEndTrim(GLUnurbs* nurb);
	const(GLubyte)*  gluErrorString(GLenum error);
	void gluGetNurbsProperty(GLUnurbs* nurb, GLenum property, GLfloat* data);
	const(GLubyte)*  gluGetString(GLenum name);
	void gluGetTessProperty(GLUtesselator* tess, GLenum which, GLdouble* data);
	void gluLoadSamplingMatrices(GLUnurbs* nurb, const(GLfloat)* model, const(GLfloat)* perspective, const(GLint)* view);
	void gluLookAt(GLdouble eyeX, GLdouble eyeY, GLdouble eyeZ, GLdouble centerX, GLdouble centerY, GLdouble centerZ, GLdouble upX, GLdouble upY, GLdouble upZ);
	GLUnurbs* gluNewNurbsRenderer();
	GLUquadric* gluNewQuadric();
	GLUtesselator* gluNewTess();
	void gluNextContour(GLUtesselator* tess, GLenum type);
	void gluNurbsCallback(GLUnurbs* nurb, GLenum which, _GLfuncptr CallBackFunc);
	void gluNurbsCallbackData(GLUnurbs* nurb, GLvoid* userData);
	void gluNurbsCallbackDataEXT(GLUnurbs* nurb, GLvoid* userData);
	void gluNurbsCurve(GLUnurbs* nurb, GLint knotCount, GLfloat* knots, GLint stride, GLfloat* control, GLint order, GLenum type);
	void gluNurbsProperty(GLUnurbs* nurb, GLenum property, GLfloat value);
	void gluNurbsSurface(GLUnurbs* nurb, GLint sKnotCount, GLfloat* sKnots, GLint tKnotCount, GLfloat* tKnots, GLint sStride, GLint tStride, GLfloat* control, GLint sOrder, GLint tOrder, GLenum type);
	void gluOrtho2D(GLdouble left, GLdouble right, GLdouble bottom, GLdouble top);
	void gluPartialDisk(GLUquadric* quad, GLdouble inner, GLdouble outer, GLint slices, GLint loops, GLdouble start, GLdouble sweep);
	void gluPerspective(GLdouble fovy, GLdouble aspect, GLdouble zNear, GLdouble zFar);
	void gluPickMatrix(GLdouble x, GLdouble y, GLdouble delX, GLdouble delY, GLint* viewport);
	GLint gluProject(GLdouble objX, GLdouble objY, GLdouble objZ, const(GLdouble)* model, const(GLdouble)* proj, const(GLint)* view, GLdouble* winX, GLdouble* winY, GLdouble* winZ);
	void gluPwlCurve(GLUnurbs* nurb, GLint count, GLfloat* data, GLint stride, GLenum type);
	void gluQuadricCallback(GLUquadric* quad, GLenum which, _GLfuncptr CallBackFunc);
	void gluQuadricDrawStyle(GLUquadric* quad, GLenum draw);
	void gluQuadricNormals(GLUquadric* quad, GLenum normal);
	void gluQuadricOrientation(GLUquadric* quad, GLenum orientation);
	void gluQuadricTexture(GLUquadric* quad, GLboolean texture);
	GLint gluScaleImage(GLenum format, GLsizei wIn, GLsizei hIn, GLenum typeIn, const(void)* dataIn, GLsizei wOut, GLsizei hOut, GLenum typeOut, GLvoid* dataOut);
	void gluSphere(GLUquadric* quad, GLdouble radius, GLint slices, GLint stacks);
	void gluTessBeginContour(GLUtesselator* tess);
	void gluTessBeginPolygon(GLUtesselator* tess, GLvoid* data);
	void gluTessCallback(GLUtesselator* tess, GLenum which, _GLfuncptr CallBackFunc);
	void gluTessEndContour(GLUtesselator* tess);
	void gluTessEndPolygon(GLUtesselator* tess);
	void gluTessNormal(GLUtesselator* tess, GLdouble valueX, GLdouble valueY, GLdouble valueZ);
	void gluTessProperty(GLUtesselator* tess, GLenum which, GLdouble data);
	void gluTessVertex(GLUtesselator* tess, GLdouble* location, GLvoid* data);
	GLint gluUnProject(GLdouble winX, GLdouble winY, GLdouble winZ, const(GLdouble)* model, const(GLdouble)* proj, const(GLint)* view, GLdouble* objX, GLdouble* objY, GLdouble* objZ);
	GLint gluUnProject4(GLdouble winX, GLdouble winY, GLdouble winZ, GLdouble clipW, const(GLdouble)* model, const(GLdouble)* proj, const(GLint)* view, GLdouble near, GLdouble far, GLdouble* objX, GLdouble* objY, GLdouble* objZ, GLdouble* objW);
}

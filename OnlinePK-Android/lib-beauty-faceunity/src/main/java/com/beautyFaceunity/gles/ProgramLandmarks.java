/*
 * // Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * // Use of this source code is governed by a MIT license that can be found in the LICENSE file.
 */
package com.beautyFaceunity.gles;

import android.hardware.Camera;
import android.opengl.GLES20;
import android.opengl.Matrix;

import com.beautyFaceunity.gles.core.Drawable2d;
import com.beautyFaceunity.gles.core.GlUtil;
import com.beautyFaceunity.gles.core.Program;

public class ProgramLandmarks extends Program {

    private static final String vertexShaderCode =
            // This matrix member variable provides a hook to manipulate
            // the coordinates of the objects that use this vertex shader
            "uniform mat4 uMVPMatrix;" +
                    "attribute vec4 vPosition;" +
                    "uniform float uPointSize;" +
                    "void main() {" +
                    // the matrix must be included as a modifier of gl_Position
                    // Note that the uMVPMatrix factor *must be first* in order
                    // for the matrix multiplication product to be correct.
                    "  gl_Position = uMVPMatrix * vPosition;" +
                    "  gl_PointSize = uPointSize;" +
                    "}";

    private static final String fragmentShaderCode =
            "precision mediump float;" +
                    "uniform vec4 vColor;" +
                    "void main() {" +
                    "  gl_FragColor = vColor;" +
                    "}";

    private static final float[] POINT_COLOR = {1.0f, 0f, 0f, 1.0f};
    private static final float POINT_SIZE = 6.0f;

    private int mPositionHandle;
    private int mColorHandle;
    private int mMVPMatrixHandle;
    private int mPointSizeHandle;

    public ProgramLandmarks() {
        super(vertexShaderCode, fragmentShaderCode);
    }

    @Override
    protected Drawable2d getDrawable2d() {
        return new Drawable2d(new float[75 * 2]);
    }

    @Override
    protected void getLocations() {
        // get handle to vertex shader's vPosition member
        mPositionHandle = GLES20.glGetAttribLocation(mProgramHandle, "vPosition");
        GlUtil.checkGlError("vPosition");
        // get handle to fragment shader's vColor member
        mColorHandle = GLES20.glGetUniformLocation(mProgramHandle, "vColor");
        GlUtil.checkGlError("vColor");
        // get handle to shape's transformation matrix
        mMVPMatrixHandle = GLES20.glGetUniformLocation(mProgramHandle, "uMVPMatrix");
        GlUtil.checkGlError("glGetUniformLocation");
        mPointSizeHandle = GLES20.glGetUniformLocation(mProgramHandle, "uPointSize");
        GlUtil.checkGlError("uPointSize");
    }

    @Override
    public void drawFrame(int textureId, float[] texMatrix, float[] mvpMatrix) {
        // Add program to OpenGL environment
        GLES20.glUseProgram(mProgramHandle);

        // Enable a handle to the triangle vertices
        GLES20.glEnableVertexAttribArray(mPositionHandle);

        // Prepare the triangle coordinate data
        GLES20.glVertexAttribPointer(
                mPositionHandle, Drawable2d.COORDS_PER_VERTEX,
                GLES20.GL_FLOAT, false,
                Drawable2d.VERTEXTURE_STRIDE, mDrawable2d.vertexArray());

        // Set color for drawing the triangle
        GLES20.glUniform4fv(mColorHandle, 1, POINT_COLOR, 0);

        // Apply the projection and view transformation
        GLES20.glUniformMatrix4fv(mMVPMatrixHandle, 1, false, mvpMatrix, 0);

        GLES20.glUniform1f(mPointSizeHandle, POINT_SIZE);

        // Draw the triangle
        GLES20.glDrawArrays(GLES20.GL_POINTS, 0, mDrawable2d.vertexCount());

        // Disable vertex array
        GLES20.glDisableVertexAttribArray(mPositionHandle);
        GLES20.glUseProgram(0);
    }

    public void drawFrame(int x, int y, int width, int height) {
        drawFrame(0, null, mMvpMatrix, x, y, width, height);
    }

    private final float[] mMvpMatrix = new float[16];
    private int mCameraType;
    private int mCameraOrientation;
    private int mCameraWidth;
    private int mCameraHeight;

    public void refresh(float[] landmarksData, int cameraWidth, int cameraHeight, int cameraOrientation, int cameraType, float[] mvpMatrix) {
        if (mCameraWidth != cameraWidth || mCameraHeight != cameraHeight || mCameraOrientation != cameraOrientation || mCameraType != cameraType) {
            float[] orthoMtx = new float[16];
            Matrix.orthoM(orthoMtx, 0, 0, cameraWidth, 0, cameraHeight, -1, 1);
            float[] rotateMtx = new float[16];
            Matrix.setRotateM(rotateMtx, 0, 360 - cameraOrientation, 0.0f, 0.0f, 1.0f);
            if (cameraType == Camera.CameraInfo.CAMERA_FACING_BACK) {
                Matrix.rotateM(rotateMtx, 0, 180, 1.0f, 0.0f, 0.0f);
            }
            float[] temp = new float[16];
            Matrix.multiplyMM(temp, 0, rotateMtx, 0, orthoMtx, 0);
            Matrix.multiplyMM(mMvpMatrix, 0, mvpMatrix, 0, temp, 0);

            mCameraWidth = cameraWidth;
            mCameraHeight = cameraHeight;
            mCameraOrientation = cameraOrientation;
            mCameraType = cameraType;
        }

        updateVertexArray(landmarksData);
    }
}
